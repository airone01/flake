+++
title = "Falling down the NixOS rabbit hole"
description = "How trying to bypass school IT restrictions led me to a love/hate relationship with a purely functional operating system."
date = 2026-03-21

[taxonomies]
categories = ["Linux", "Homelab"]
tags = ["nix", "arch", "rant", "42"]
+++

If you look at my GitHub, you'll see a massive, multi-host Nix flake managing
everything from my main PC to my VPS. But I wasn't always like this.

There was a time when I lived a normal life. A normie life I might add.

I daily-drove Arch on laptop for my CS work, kept a Windows 11 install on my
gaming machine, and spun up VMs to bypass the restrictions on the school
computers at 42 that run Ubuntu.

They locked down `sudo`, but left us with QEMU and Docker rights. This is
required for learning, and may or may not have been abused to the brim by
students I won't name (I ain't a snitch).

So how did I end up here, writing purely functional, declarative configurations
for every machine I own?

### The Gateway Drug

It started innocently enough. Like many students before me, I was annoyed by the
limited environment at school and wanted to hack together a working package
manager that didn't require root privileges. Like many students before me, I
ended up never finding a durable way to make that "easy package manager" dream
come true. But in my research, I stumbled upon Nix, as in the package manager,
not the OS.

I installed the standalone binary at home just to see what the hype was about.
It was neat. Then, out of curiosity, I spun up the full NixOS in a VM. Then I
wiped a spare laptop and put it on bare metal. After hours of staring at error
messages and debugging things that should have been simple (and countless
Monster Energy drank), I realized I was hooked.

### An Addiction Worse than Factorio

The tipping point—the moment I realized I could never go back to a traditional
Linux distro—happened when I needed to sync my environment across machines.

I was setting up my main PC (`lyra`) and my laptop (`cassiopeia`). Normally,
this is where you clone your dotfiles repo, run some `setup.sh` script full of
symlinks, and pray you didn't forget to install a dependency.

With NixOS? I just pointed the flake at the new host, rebuilt and switched,
and... it was there. Everything. My Neovim plugins (well not really, I installed
[nvf](https://nvf.notashelf.dev/) later, but you get the point), my Hyprland
binds, my shell aliases.

That was fucking dope.

### Stockholm Syndrome

I love NixOS, but I also hate it. I need to be brutally honest with anyone
standing at the edge of this rabbit hole: the learning curve is practically a
vertical cliff.

The Nix language itself is _okay_, but the documentation is sparse at best and
completely non-existent at worst. When things break, the debugging process is
horrible. It almost requires you to have already stumbled upon "this specific
bug" in a past life or in the past month to know how to fix it.

Coming from Arch, I am fully accustomed to the RTFM mentality. But with Arch,
_there is actually a manual to read_. The Arch Wiki is a masterpiece. The NixOS
Wiki is... getting better, but usually ends up being a graveyard of outdated
snippets.

No offence to the Nix Wiki team, it's getting there, and there are logical ways
it is the way it is right now, mainly that Nix is just moving so fast!
Considering all that, it's really not that bad, I doubt I could maintain
articles about Nix like they do. Anyway.

### The Real Documentation: Other People's Code

So, how do you actually learn NixOS? You read other people's dotfiles.

I owe my sanity—and a large portion of my current configuration—to the
community. People like `isabelroses`, `NotAShelf`, and countless random GitHub
users whose repositories I've scoured at 2 AM (and that I forgot about, sorry.
If I remember you, I'll display your name here). Sometimes in the Nix community,
source code might be the only true documentation.

I don't regret switching one bit though. I'll take the cryptic error messages
over a broken system update any day of the week. But if you decide to take the
plunge, just know what you're getting into (and you don't, really you don't).
Grab a coffee (or 3), prepare to read a lot of source code, and whatever you do,
back everything up before starting.
