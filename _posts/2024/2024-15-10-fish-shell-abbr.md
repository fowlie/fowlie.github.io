---
title: Fish Shell Abbreviations - Next Level Aliases
layout: post
date: 2024-10-15 00:00:00 +0000
comments: false
---
I've been using Fish shell for quite some time now, and it’s by far the most user-friendly command-line interface I've encountered. But what makes Fish different from other popular shells like Bash or Zsh? Fish enhances your command-line productivity without overwhelming you, thanks to its intuitive features and smart defaults. In this post, I’ll walk you through some of my favorite features that make Fish stand out.

Fish offers features like autosuggestions, syntax highlighting, and a web-based configuration tool—all out of the box. These features save time and reduce errors without requiring heavy customization. But enough talk—let’s dive into how Fish improves your workflow in real, practical ways.

## My Git Commit Routine

Now, let me show you one way Fish makes my daily workflow smoother—especially when working with Git.

Whenever I make a change I want to commit to git, I always zoom out a bit before staging my changes. That way, I won't accidentally commit files I didn’t mean to add or forget to remove those "TODO fix later" comments. This isn’t a complex task, but if you're a terminal person like me, you’ll appreciate this simple yet powerful git command:

```shell
git add --patch # or -p for short
```

The patch flag interactively shows you each hunk of code and its diff, asking what you want to do with it:

```shell
(1/1) Stage this hunk [y,n,q,a,d,e,?]? ?
y - stage this hunk
n - do not stage this hunk
q - quit; do not stage this hunk or any of the remaining ones
a - stage this hunk and all later hunks in the file
d - do not stage this hunk or any of the later hunks in the file
e - manually edit the current hunk
? - print help
```

_The help text here only shows if you press `?`, which is handy if you forget what the options do._

After reviewing and staging my changes, I create a commit with the good old `git commit -m 'new feature x'`. Simple and efficient.

## Fish Abbreviations

You might be familiar with aliases, which are useful for saving keystrokes. For instance, you could alias `git commit` to `gc` with the command:

```shell
alias gc='git commit'
```

Now, typing `gc -m 'new feature x'` will invoke the  `git commit` command. But Fish has something even cooler—**abbreviations**. Abbreviations work similarly to aliases, except that when you type the abbreviation, pressing space or enter will expand it into the full command automatically.

Here’s how to create one:

```shell
abbr --add gc git commit
```

Now, whenever you type `gc` and press space, Fish will automatically expand it into `git commit`. This makes your command history cleaner, since you’ll see the full commands rather than just aliases.

But here’s the real magic: Fish abbreviations can be designed to move the cursor after expansion. For example, you could create an abbreviation that expands into `git commit -m ''` and places the cursor inside the quotes, ready for you to type your commit message!

```shell
abbr --add --position anywhere --set-cursor='%' -- gcm git\ commit\ -m\ \'\%\'
```

Now, when you type `gcm`, it expands and puts your cursor in the perfect spot to enter the message. This feature adds convenience and reduces hassle, especially in repetitive tasks like git commits.