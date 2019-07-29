---
layout: post
title:  "How to setup Ruby and Jekyll on your local machine"
date:   2019-07-29 19:35:49 +0100
categories: jekyll installation blog
---

Unfortunately the most time I spend during the day is using Windows, so I tried the best method to use as many Free (as in freedom) tools possible. 

To test Jekyll in order to avoid the configuration of [RubyInstaller](https://rubyinstaller.org/) as suggested by the Jekyll [website](https://jekyllrb.com/docs/installation/windows/), I went for WLS installation (Windows Linux Subsystem) of Debian (I don't like Ubuntu BTW).

So after installing Debian, by simply search and install Debian from [Microsoft Store](https://www.microsoft.com/store/productId/9MSVKQC78PK6) and configured some a username, firstly I tried to install Ruby v 2.5.x or higher as the Jekyll website suggested so:
```
    $ sudo apt-get update -y && sudo apt-get upgrade -y
    $ sudo apt-add-repository ppa:brightbox/ruby-ng
```
Nope.

I got 2 errors.

Keep in mind I'm pretty much ages I don't use debian and related GNU/Linux distros so I felt completely lost. 

Luckily in less than 10 minutes I figure out:

    1. you cannot use apt-add-repository out-of-the-box on a Debian 9 installation (bah..)
    2. You cannot install a package from a ubuntu ppa on Debian (seems legit, but isn't Ubuntu based on Debian?)
    3. now I remember why I move from GNU/Linux to macOs years ago
    4. I was completely missing the point of Debian vs. Ubuntu
    5. Everybody consider Ubuntu as default distro for GNU/Linux users which is scary 

I leave you in side notes of this article some advice to make apt-add-repository make it work on Debian and make GPG work with dirmngr for network operations, something not related to but useful in daily usage of the system.  

So, in order to complete a simple and pretty trivial task I change completely the way to install Ruby and use [RbEnv](https://github.com/rbenv/rbenv):
```
    $ # Prepare your system to install rbenv and ruby-build script
    $ sudo apt install git curl libssl-dev libreadline-dev zlib1g-dev autoconf bison build-essential libyaml-dev libreadline-dev libncurses5-dev libffi-dev libgdbm-dev
    $ # Actually install REnv (make sure you are on bash)
    $ curl -sL https://github.com/rbenv/rbenv-installer/raw/master/bin/rbenv-installer | bash -
```
Again I got an error message:
```
Installing rbenv with git...
Initialized empty Git repository in /home/zack/.rbenv/.git/
Updating origin
remote: Enumerating objects: 2706, done.
remote: Total 2706 (delta 0), reused 0 (delta 0), pack-reused 2706
Receiving objects: 100% (2706/2706), 496.86 KiB | 428.00 KiB/s, done.
Resolving deltas: 100% (1710/1710), done.
From https://github.com/rbenv/rbenv
 * [new branch]      master     -> origin/master
 * [new tag]         v0.1.0     -> v0.1.0
 * [new tag]         v0.1.1     -> v0.1.1
 * [new tag]         v0.1.2     -> v0.1.2
 * [new tag]         v0.2.0     -> v0.2.0
 * [new tag]         v0.2.1     -> v0.2.1
 * [new tag]         v0.3.0     -> v0.3.0
 * [new tag]         v0.4.0     -> v0.4.0
 * [new tag]         v1.0.0     -> v1.0.0
 * [new tag]         v1.1.0     -> v1.1.0
 * [new tag]         v1.1.1     -> v1.1.1
 * [new tag]         v1.1.2     -> v1.1.2
Branch master set up to track remote branch master from origin.
Already on 'master'
make: Entering directory '/home/zack/.rbenv/src'
gcc -fPIC     -c -o realpath.o realpath.c
gcc -shared -Wl,-soname,../libexec/rbenv-realpath.dylib  -o ../libexec/rbenv-realpath.dylib realpath.o
make: Leaving directory '/home/zack/.rbenv/src'

Installing ruby-build with git...
Cloning into '/home/zack/.rbenv/plugins/ruby-build'...
remote: Enumerating objects: 65, done.
remote: Counting objects: 100% (65/65), done.
remote: Compressing objects: 100% (38/38), done.
remote: Total 9777 (delta 26), reused 51 (delta 19), pack-reused 9712
Receiving objects: 100% (9777/9777), 2.08 MiB | 1.21 MiB/s, done.
Resolving deltas: 100% (6352/6352), done.

Running doctor script to verify installation...
Checking for `rbenv' in PATH: not found
  You seem to have rbenv installed in `/home/zack/.rbenv/bin', but that
  directory is not present in PATH. Please add it to PATH by configuring
  your `~/.bashrc', `~/.zshrc', or `~/.config/fish/config.fish'.
```
This time is too easy to fix it. 
As the error itself suggests the .rbenv/bin is missing from my PATH. 

Ok, fine. 

Let's add it.

```
    $ echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
    $ echo 'eval "$(rbenv init -)"' >> ~/.bashrc
    $ source ~/.bashrc
    $ # As requested in Jekyll docs we install dh-autoreconf
    $ sudo apt-get install dh-autoreconf  
```
Still using bash right now in my WLS, change .bashrc with .zshrc if you're using ZSH.
As explained in [this](https://linuxize.com/post/how-to-install-ruby-on-debian-9/) nice guide.

So right now I can finally install Ruby:
```
    $ rbenv install 2.5.0 
    $ rbenv global 2.5.0
    $ rbenv install 2.5.0-dev
    $ # Now we can install Jekyll via Gem but before we perform a Gem Update
    $ gem update --system
    $ bundle install
    $ # Now you should be able to install jekyll
    $ gem install jekyll bundler
```
In my case I already had a Jekyll installation so I just clone my repository:
```
    $ mkdir development
    $ cd ~
    $ cd development && git clone https://github.com/simonekalb/simonekalb.github.io.git
```
So inside the last directory make sure you don't have any Gemfile.lock in case you can safely remove it as it can generate some version mismatch errors.
```
    $ jekyll serve --no-watch --baseurl ""
```
The ```--nowatch ``` flags avoid auto-regeneration on Bash Windows version, that has [bugs](https://github.com/Microsoft/BashOnWindows/issues/216).

So from Windows you can connect to your Jekyll installation by connecting to http://127.0.0.1:4000/

### Conclusions

I believe that if WLS is a great tool on Windows, Jekyll is not a really friendly environment to set up as I encountered a lot of strange errors and misconfiguration that the same Jekyll website won't address.

I remember having same issues on macOs, so probably the whole bundle is kinda broken. 

So to sum it up I installed versions:
```
    $ gem -v
2.7.3
    $ ruby -v
ruby 2.5.0p0 (2017-12-25 revision 61468) [x86_64-linux]
    $ jekyll -v
jekyll 3.8.6
```
It was unnecessary tricky but at least I managed to complete the task in more or less 4 hours while writing this guide to you avoid to get mad trying to do it. 

So you can get a working test environment in less than 2 hours. 

#### Side note

As a side note I leave you 2 tricks a novice can come across while tryin' to use ppa on debian.
First of all you cannot use ```
apt-get-repository``` out-of-the-box in Debian 9.
You should install:
```
    sudo apt-get install software-properties-common
```
Which install a lot of unneccessary crap.
And in order to install a repository remember that Debian won't use ```dirmngr``` install recommendation by default so you have to:

```
    $ sudo apt-get install dirmngr --install-recommends
```
As [somebody](https://blog.sleeplessbeastie.eu/2017/11/02/how-to-fix-missing-dirmngr/) smarter than me pointed out.

Now you should be able to add any remote repository.




