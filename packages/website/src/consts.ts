import type { IconMap, SocialLink, Site } from "@/types";

export const SITE: Site = {
  title: "r1's place",
  description: "A simple blog and archive.",
  href: "https://air1.one",
  author: "airone01",
  locale: "en-US",
  featuredPostCount: 2,
  postsPerPage: 3,
};

export const NAV_LINKS: SocialLink[] = [
  {
    href: "/blog",
    label: "blog",
  },
  {
    href: "/whois",
    label: "whois",
  },
  {
    href: "/about",
    label: "about",
  },
];

export const SOCIAL_LINKS: SocialLink[] = [
  {
    href: "https://github.com/airone01/flake",
    label: "GitHub",
  },
  {
    href: "mailto:erwann.lagouche@gmail.com",
    label: "Email",
  },
  {
    href: "/rss.xml",
    label: "RSS",
  },
];

export const ICON_MAP: IconMap = {
  Website: "lucide:globe",
  GitHub: "lucide:github",
  LinkedIn: "lucide:linkedin",
  Twitter: "lucide:twitter",
  Email: "lucide:mail",
  RSS: "lucide:rss",
};
