import os
import re
import datetime
import requests
from atproto import Client, client_utils

BSKY_HANDLE = os.environ.get("BSKY_HANDLE")
BSKY_PASSWORD = os.environ.get("BSKY_PASSWORD")
GITHUB_TOKEN = os.environ.get("GITHUB_TOKEN")


def get_yesterday_str():
    yesterday = datetime.datetime.now(datetime.timezone.utc) - datetime.timedelta(
        days=1
    )
    return yesterday.strftime("%Y-%m-%d")


def fetch_merged_prs(date_str):
    query = f'repo:NixOS/nixpkgs is:pr is:merged merged:{date_str} "init at" in:title'
    url = "https://api.github.com/search/issues"
    headers = {"Accept": "application/vnd.github.v3+json"}

    if GITHUB_TOKEN:
        headers["Authorization"] = f"token {GITHUB_TOKEN}"

    resp = requests.get(url, params={"q": query, "per_page": 100}, headers=headers)
    resp.raise_for_status()
    return resp.json().get("items", [])


def parse_pkg_name(title):
    """extracts package name"""
    match = re.search(r"^([^:]+):", title)
    return match.group(1).strip() if match else title[:25]


def main():
    if not BSKY_HANDLE or not BSKY_PASSWORD:
        print("missing Bluesky creds")
        return

    target_date = get_yesterday_str()

    # login to Bluesky
    client = Client()
    try:
        client.login(BSKY_HANDLE, BSKY_PASSWORD)
    except Exception as e:
        print(f"Failed to login to Bluesky: {e}")
        return

    # check if we already posted about target date
    try:
        feed = client.get_author_feed(actor=BSKY_HANDLE, limit=5)
        for item in feed.feed:
            if (
                hasattr(item.post.record, "text")
                and f"({target_date})" in item.post.record.text
            ):
                print(f"Already posted for {target_date}. Skipping.")
                return
    except Exception as e:
        print(f"Could not fetch feed (Error: {e}). Assuming it's safe to post.")

    prs = fetch_merged_prs(target_date)
    if not prs:
        print(f"No packages found for {target_date}.")
        return

    tb = client_utils.TextBuilder()
    tb.text(f"📦 New in #nixpkgs ({target_date}):\n\n")

    footer_text = "\n\nFull list on GitHub"
    footer_url = f"https://github.com/nixos/nixpkgs/pulls?q=is%3Apr+is%3Amerged+merged%3A{target_date}+%22init+at%22+in%3Atitle"

    limit = 300
    current_visible_len = len(tb.build_text())
    footer_len = len(footer_text)

    for pr in prs:
        name = parse_pkg_name(pr["title"])
        link_label = f"#{pr['number']}"

        line_intro = f"• {name} ("
        line_outro = ")\n"

        row_len = len(line_intro) + len(link_label) + len(line_outro)

        if current_visible_len + row_len + footer_len > limit:
            break

        tb.text(line_intro)
        tb.link(link_label, pr["html_url"])
        tb.text(line_outro)
        current_visible_len += row_len

    tb.link(footer_text, footer_url)

    client.send_post(tb)
    print(f"posted for {target_date}!")


if __name__ == "__main__":
    main()
