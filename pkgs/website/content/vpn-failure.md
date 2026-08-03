+++
title = "(Why) I gave up on site-to-site VPNs (and learned to embrace Traefik)"
description = "The dream of a perfect WireGuard mesh, the reality of broken routing tables, and why I pivoted to IP whitelisting."
date = 2026-03-22

[taxonomies]
categories = ["Homelab", "Networking"]
tags = ["nix", "traefik", "wireguard", "rant"]
+++

If you hang around homelab circles long enough, you eventually get sold on the
dream of the perfect site-to-site VPN.

The pitch is beautiful: _Why expose your services to the big, bad internet when
you can link your VPS, your local hypervisor, and your laptop into one seamless,
encrypted mesh?_ I bought into that dream. I wanted `hercules` (my VPS) and
`cetus` (my homelab server) to talk to each other like they were sitting on the
same switch. I wanted my main PC (`lyra`) and my laptop (`cassiopeia`) to
magically resolve internal services no matter what coffee shop I was sitting in.

Spoiler alert: It failed miserably.

### The Descent into Madness

Setting up a basic WireGuard tunnel in NixOS isn't too bad. But when you start
trying to do proper site-to-site routing—dealing with NAT traversal, dynamic
endpoints, and `systemd-networkd`—things get messy fast.

My Nix flake started accumulating layers of messy networking hacks. I was
fighting asymmetric routing, where packets would go out the VPN interface but
try to return via the default gateway. I'd reboot a machine and suddenly lose
SSH access because the VPN interface didn't come up before the firewall rules
locked everything down.

Instead of spending my time actually _building_ things, I became a full-time
janitor for my own routing tables. I was over-engineering a solution to a
problem that didn't need to be this complicated.

### The Pivot: Keep It Simple, Stupid

I finally stepped back and asked myself: _What am I actually trying to achieve?_
I just wanted secure access to my self-hosted services without leaving them wide
open to bots scanning the internet. I didn't need a complex Layer 3 mesh
network; I just needed a decent bouncer at the door.

So, I ripped the VPN out of my Nix configs and pivoted back to my trusty reverse
proxy: **Traefik**.

Instead of tunneling all my traffic, I'm now just exposing what needs to be
exposed via Traefik, but leaning heavily on IP whitelisting.

- Public stuff (like this blog) stays open.
- Internal tools and dashboards are restricted at the proxy level to only accept
  connections from known IPs.

### Peace of Mind

It’s not as "cool" as having a zero-trust mesh overlay network. But you know
what it is? **Reliable.** My Traefik configuration in NixOS is completely
declarative, it handles my Let's Encrypt certificates automatically, and it just
_works_. I don't have to worry about MTU sizes breaking my SSH sessions, and I
don't have to troubleshoot why my laptop can't reach Gitea after waking up from
sleep.

Sometimes, the "boring" Web 1.0/2.0 way of doing things is the right way.
Restrict the listening IPs, secure your apps, and get your weekends back.
