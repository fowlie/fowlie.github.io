---
title: Two-factor the easy way with pass, GPG and TOTP
layout: post
date: 2025-10-10 00:00:00 +0000
---
I’ve written before about using the Unix-friendly password manager “pass.” It’s still my favorite because it stays out of the way and plays nicely with the command line. This time, I’m taking it a step further: storing and generating 2FA codes (TOTP) with `pass`, backed by my GPG key. No more reaching for my phone just to log in.

Below is how I set this up on Linux.

## 1) Install the tools

```bash
sudo pacman -S pass gnupg oath-toolkit zbar
```

- `pass`: the password store
- `gnupg`: encryption via your GPG key
- `oath-toolkit`: generates TOTP codes (used under the hood)
- `zbar`: scans QR codes (so you can grab the TOTP secret from a PNG/SVG)

For Debian/Ubuntu: `sudo apt install pass gnupg oathtool zbar-tools`

## 2) Create or import a GPG key

Check if you already have one:

```bash
gpg --list-keys
```

If not, generate a new one:

```bash
gpg --full-generate-key
```

Find your key ID afterwards:

```bash
gpg --list-keys
```

## 3) Initialize `pass` with your GPG key

```bash
pass init <KEYID>
```

This creates `~/.password-store/`, where your secrets live—encrypted with your key.

## 4) Add the TOTP secret

You can use the OTP extension to import the QR/URI directly.

Install the `pass-otp` package.

On Arch:

```bash
yay -S pass-otp
```

On Debian/Ubuntu:

```bash
sudo apt install pass-extension-otp
```

Now you can import the QR directly (it will parse and store the secret properly):

```bash
pass otp insert totp/my-company
```

You can paste the full `otpauth://…` URI here, or point it at a QR image depending on your workflow.

## 5) Generate one-time codes

Once the secret is stored, generating a code is just:

```bash
pass otp totp/my-company
```

Or copy it straight to the clipboard:

```bash
pass otp -c totp/my-company
```

I love that this works anywhere I have my GPG key, and it keeps my 2FA setup entirely in my password store.

## 6) Optional: a quick keybinding (Hyprland)

As a quality-of-life tweak, I set up a Hyprland binding that types the current TOTP code into the focused field. The idea is simple: grab the code from `pass`, strip the trailing newline, and “type” it.

In `bindings.conf`:

```ini
bindd = SUPER SHIFT, T, SVVToken, exec, bash -c 'sleep 0.2; wtype -- "$(pass otp totp/my-company | tr -d "\n")"'
```

Tweak the key combo, entry path, and delay to taste. You’ll need `wtype` (Wayland) or an equivalent for your environment.

---

That’s it! If you’re already living in the terminal, this setup feels incredibly natural. pass remains the single source of truth, GPG keeps it safe, and your 2FA codes are right where you need them—no phones, no fumbling.
