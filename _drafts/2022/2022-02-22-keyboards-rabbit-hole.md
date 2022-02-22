---
title: down the mechanical keyboard rabbit hole
layout: post
date: 2022-02-22 00:00:00 +0000
comments: true

---
A few years ago a collegue of mine introduced me to 60% keyboards. Today, I'm
typing this blogpost on a 42 key US Colemak Mod-DH layout. With this blogpost I
will try to share what my journey was like.

Many people are afraid of keyboards like these and might try to talk you out of
buying one. To them, I say this: Your keyboard is kind of like your instrument
in your profession. Professional musicians don't play on crappy equipment,
right?

I'm writing this to share my story on how I navigated through a jungle of
keyboards and layouts. This is what my current setup looks like:
<img src="/uploads/2022/setup-home-office.webp" alt="setup home office" class="img-fluid" />


# US Layout while typing norwegian
If you are already using a US keyboard layout, go ahead and skip this
paragraph. So you're still here, that might mean that you're using some
europeian layout, am I right? The norwegian layout is terrible for coding,
because you'd use the right-alt modifier to type many special characters. I
didn't have a keyboard with a US layout, so I just printed out a cheat sheet
and put it on my desk. So after a few days of getting used to the new positions
of the special characters, I really enjoyed the feeling. In the beginning I was
switching between US and NO layout in the operative system with a keybinding.
It worked fine, but a lot of times I would type the wrong characters only to
realize I was typing with the wrong layout.

## EurKey to the rescue
I discovered a keyboard layout you can install on your computer which is made
by a german fella and is based on the US layout. It is called EurKey, and the
way you would type europeian special letters is by pressing the right-alt
followed by another key. For instance, `right-alt + q` would print `æ`,
`right-alt + l` prints `ø` and `right-alt + w` prints `å`.

# My first mechanical keyboard
A collegue of mine showed me his [Happy Hacking Keyboard](https://happyhackingkb.com)
which is a mechanical keyboard with no arrows. When he later bought a brand new
[WASD 61 key](https://www.wasdkeyboards.com/wasd-vp3-61-key-custom-mechanical-keyboard.html)
keyboard with CherryMX Brown switches I was sold and decided to try for myself.
I went for the [Anne Pro 2](https://www.annepro.net/products/anne-pro-2) which
was similar, but cheaper and actually programmable. It's also wireless and the
battery lasts for a week or more. I really love this keyboard!

<img src="/uploads/2022/anne-pro-2.webp" alt="anne pro 2 keyboard" title="Anne Pro 2" class="img-fluid" />

Being a vim user, I mapped the `hjkl` keys to act like arrow keys. Also with
the Vimium extension for Firefox, I could use the vim-keybinding everywhere!

# Death of the Caps lock key
Emacs users often get the credits for inventing this hack. And that hack is
about realizing how stupid they caps lock key really is. Well, maybe not stupid,
but unless you write SQL all day long, you're not using it enough for it to
deserve such a good position right there on the home row on your keyboard.
Replace it with ctrl! If your keyboard firmware has the ability to map
different values when you hold or tap a key, you can even map it to `Esc` when
you tap it and `ctrl` when holding it. You can do this easily on the Anne Pro
2.

If you feel for a laugh, checkout this funny little post about improving design
by removing useless stuff:
https://memex.marginalia.nu/log/48-i-have-no-capslock.gmi

# Moonlander, the keyboard from heaven?
The Moonlander from ZSA is an ergonomic, split, ortholinear mechanical and
programmable keyboard. By the way, ortholinear means that all the keys are
arranged as if in a grid rather than the classic typewriter layout. You can
program it to do basically anything you want with different layers, macros and
also tap and hold can do different things. You can even control the mouse, or
create a seperate layer for stenography if you're into that sort of thing. It's
also very expensive,  Wanted it for months and finally ordered it. Took like 3
days to ship it all the way from Taiwan, very impressive! This keyboard is a
monster, and you have to tame it before you can use it. I printed out all the
layers and hung them up on my desk. I quickly iterated different layouts on the
thumb clusters, but it never quite felt natural. It's a strange feeling to mess
around with keys like `ctrl`, `backspace` and `enter`. It hurts to adjust your
brain to a keyboard like this. After a few months I stopped using it. It was
just too big (coming from a 60% layout), and I have relative short pinkies so
touch typing was not a good experience.

# Done with Moonlander (for now)
Why did I mention a keyboard I stopped using anyways? Because I found a way to
make it work like a charm, but since I'm writing this in a chronological order,
we are going down another rabbit hole first. A rabbit hole in another rabbit
hole. Yes. There's actually a whole maze down here. We're entering the keyboard
layout rabbit sub-hole.

I've always liked simple solutions to complex problems (or even avoiding the
problem in the first place), and while the qwerty layout isn't so bad, it's
designed for the mechanical type writer in mind. When designing a keyboard
layout for a computer, you could start from scratch. In my head, this is reason
enough to ditch qwerty! So I then re-programmed my keyboard with a Colemak
layout, and rearranged all the key caps. This feels really painful at first,
but after a couple of weeks my typing speed slowly came to a point where I
could use it at work. But I never liked loosing the vim-keys I was so used to,
like the `hjkl`, and I switched back to qwerty for a long time.

Inspired by [ThePrimeagen](https://www.youtube.com/theprimeagen),
I decided to learn the `dvorak` keyboard layout. I noticed that the `j` and `k`
was next to each other, which fits nice with the vim-keys. After switching my
typing speed dropped from ~80 wpm to 8 wpm! I got up to about 50 wpm with
dvorak on my Anne Pro 2 keyboard. At this point I started to notice how my
right ring finger was stretching up to reach the `L` key all the time, and it
was starting to get annoying. So I decided to ditch dvorak, and went back to
qwerty. But once in a rabbit hole, you can't get back up.

# Workman and Colemak Mod-DH
I stumbled over the [Workman layout](https://workmanlayout.org), a modern
layout designed to solve some issues with the Colemak layout. I had never heard
of Colemak either, but I thought Workman layout sounded awesome, and I decided
to try it out. I liked this layout from the first word I typed, and it wasn't
that much different from qwerty either, so the learning curve was nicer than
with dvorak. After reading some critism about Workman and how it sucked to type
the word `fuel` I discovered another Colemak variant called [Colemak
Mod-DH](https://colemakmods.github.io/mod-dh). The name says it all, because it
basically takes the Colemak layout and moves the D and H keys away from the
center columns (one row down and one step outwards). I'm pretty happy with this
layout, and while not typing at 80 wpm yet, I'm determined to go all in on this
one.

# Reducing Moonlander to a 42 keys layout
I came across [Ben Vallack's channel on Youtube](https://www.youtube.com/benvallack)
where he talks about surviving with 42 keys. He actually used a Moonlander
keyboard and had physically removed all unused keys. I liked the idea of less
keys, as my fingers would better reach every corner of the keyboard without me
having to move my hands so much.

<img src="/uploads/2022/moonlander-closeup.webp" alt="moonlander closeup" title="Moonlander 42 keys layout" class="img-fluid" />

The main challenge would be to create a layout
that would fit all the neccessary keys, and create meaningful layers that are
not hard to learn or use. I borrowed a lot of ideas from Ben, but I have also
tried to make it fit for my own needs as well. You can [check out my layout
here](https://configure.zsa.io/moonlander/layouts/QqK6B/latest/0).


# Future plans
Now I have the layout I want, I need to train myself to type fast again. I can
recommend checking out [monkeytype.com](https://monkeytype.com). There you can
even use a normal qwerty keyboard, press `Esc` or go to settings and choose
"Layout emulator". Another tip is to enable stop on error, so that it forces
you to hit the correct key. To enable this, again go to settings and "Stop on
error" followed by either "letter" or "word".

I'm also looking for the perfect keyboard to match this setup, which I'm pretty
satisfied with as of now. However, this deep down in the rabbit hole, I'm not
going to find the perfect keyboard at amazon.com. I need to build one myself.
Luckily many people actually do this, and share their PCB design at github.com
as open source! There's a comprehensive list of them [here](https://keebfolio.netlify.app/#keyboards).
I'm looking for a 3x6+3 keys with low profile switches and possibly bluetooth.
Hopefully that's what my next blog post will be about.


# References
- [The European keyboard layout homepage](https://eurkey.steffen.bruentjen.eu)
- [Dvorak keyboard layout article on Wikipedia](https://en.wikipedia.org/wiki/Dvorak_keyboard_layout)
- [The Workman keyboard layout](https://workmanlayout.org)
- [The Colemak keyboard layout homepage](https://colemak.com)
- [The Colemak Mod-DH homepage](https://colemakmods.github.io/mod-dh)
- [MonkeyType for type training](https://monkeytype.com)
- [Ben Vallack's Youtube channel](https://www.youtube.com/benvallack)
- [My Moonlander layout configuration](https://configure.zsa.io/moonlander/layouts/QqK6B/latest/0)
- [Anne Pro 2 keyboard](https://www.annepro.net/products/anne-pro-2)
- [Moonlander keyboard](https://www.zsa.io/moonlander)
- [GergoPlex keyboard (DIY)](https://kowodo.github.io/HardwareTools/gergoPlex.html)
- [Ferris keyboard (DIY)](https://github.com/pierrechevalier83/ferris)
- [Keebfolio, a comprehensive list of keyboards](https://keebfolio.netlify.app)
- [Keyboard layout editor](http://www.keyboard-layout-editor.com)
