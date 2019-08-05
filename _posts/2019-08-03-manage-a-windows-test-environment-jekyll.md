---
layout: post
title:  "How to manage a test development environment in Windows for Jekyll"
date:   2019-08-03 19:35:49 +0100
categories: jekyll blog test windows
---

Hi, there, today I would like to write about something I personally surprised me more than ever.
Yes, that's because using WSL in Windows is surprisingly good.

## What is WSL and why we should bother
Windows Subsystem for Linux, or WSL for short, is a really cool piece of technology brought by Microsoft in August 2016 for the first time and in June 2019 with the introduction of WSL 2.

Essentially we talking about a compatibility layer between Windows and GNU/Linux. 
Microsoft claims that you can run linux applications and utilites inside Windows 10 (and Windows server 2019) without the overhead of some form of virtualization.

In this article we talking about WSL 2, available through the Windows Insider Program starting from June 2019. The WSL 2 technology is based on light virtualization technologies in order to run a set of customized GNU/Linux distribution with custom kernel images.

The incredible thing is that users can now access the same file from Windows AND Linux, so different programs one running from Windows and the other from Linux can access the same set of files.

This gives a developer an incredible amount of flexibility: first of all, services like LAMP architectures (does somebody still use it?) can be installed on WSL machine and accessed by project on Windows developed in PHP Storm for example, thus removing the hassle of install all the complicated, ported to Windows, Unix tools that nobody wants to install on Windows. 

Think about MSYS, CygWin, Angular, or Python and Ruby. Installing tools like this for development in Windows is always been a pain in the ass historically. You have to mess with Path and file system convention for UNIX in Windows and annoying stuff.

But using WSL developers like me, forced to use Windows on a daily job can actually enjoy the freedom to install a new development environment in a breeze and access it from Windows as fast as you can. Snappy!

As we already seen in order to install WSL you have to manually enable the functionality inside the operating system by opening a Powershell in administrator mode and type:
```powershell
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
```

and you're good to go.

Firstly open the Microsoft Store and search for one of the few linux distribution you can install as today on Windows (can you believe? Linux on Windows?):

* [Kali Linux](https://www.microsoft.com/store/productId/9PKR34TNCV07)
* [Ubuntu](https://www.microsoft.com/store/productId/9NBLGGH4MSV6) 
* [Ubuntu 18.04 LTS](https://www.microsoft.com/store/productId/9N9TNGVNDL3Q)
* [Debian](https://www.microsoft.com/store/productId/9MSVKQC78PK6) 
* [SUSE Linux Enterprise Server 15](https://www.microsoft.com/store/productId/9PMW35D7FNLX)
* [Alpine WSL](https://www.microsoft.com/store/productId/9P804CRF0395)
* [OpenSUSE Leap 15.1](https://www.microsoft.com/store/productId/9NJFZK00FGKV)

I chose Debian because its freedom and the goal the project and for the incredible amount of documentation you can find online. So maybe some command in the rest of the article should not work properly if you use another non-debian distros.

Once started debian you'll be asked for username and password for your account, choose one and sign it down somewhere to make sure you won't forget it.

### Build an environment 

By default Ruby is not installed on Debian and as we alredy seen in previous posts we can install it with a tool that makes installation of a specific version of Ruby a breeze. This tool is called [rbenv](https://github.com/rbenv/rbenv) which stands for Ruby Environment (if you ever worked with the Python programming language you may recognize similarities with [pyenv](https://github.com/pyenv/pyenv)). 

To install Rbenv make sure you write on bash:
```bash
$ # Prepare your system to install rbenv and ruby-build script
$ sudo apt install git curl libssl-dev libreadline-dev zlib1g-dev autoconf bison build-essential libyaml-dev libreadline-dev libncurses5-dev libffi-dev libgdbm-dev
$ # Actually install REnv (make sure you are on bash)
$ curl -sL https://github.com/rbenv/rbenv-installer/raw/master/bin/rbenv-installer | bash -
```
You eventually got some error for PATH properly set.

So fix it like (on bash):
```bash
$ echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
$ echo 'eval "$(rbenv init -)"' >> ~/.bashrc
$ source ~/.bashrc
$ # As requested in Jekyll docs we install dh-autoreconf
$ sudo apt-get install dh-autoreconf 
```
or like that:
```zsh
$ echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.zshrc
$ echo 'eval "$(rbenv init -)"' >> ~/.zshrc
$ source ~/.zshrc
$ # As requested in Jekyll docs we install dh-autoreconf
$ sudo apt-get install dh-autoreconf 
```
if you're using zsh as default shell (we'll see how to change it in a future article).

## Install Ruby via RbEnv

So right now you can finally install Ruby:
```bash
    $ rbenv install 2.5.0 
    $ rbenv global 2.5.0
    $ rbenv install 2.5.0-dev
    $ # Now we can install Jekyll via Gem but before we perform a Gem Update
    $ gem update --system
    $ bundle install
    $ # Now you should be able to install jekyll
    $ gem install jekyll bundler
```
you should be see an installation of jekyll.

### VSCodium as opposed to VSCode

In the recent years [VSCode](https://code.visualstudio.com/) has become very very popular as IDE for the most important 3 OSes (Windows, macOS, GNU/Linux) and using it I must say it's incredibly versatile and supports a lot of programming languages, such as JS, TypeScript,  Python, Go and moreover C/C++, via an easy-to-install plugin system.

But, altrough VSCode is released under a MIT licence, when distributing binaries, Microsoft clones the repository, adds telemetry and icons and then produces a build which is not released under a non [open source licence](https://code.visualstudio.com/license).

As I try to be very careful on installing unnecessary closed source software on my machine I found [VSCodium](https://vscodium.com/) to perfectly fit my needs. I got the best of two worlds. As in this case I'm using Windows I installed with Chocolatey which is my default package manager on Bill Gates' preferred platform, run this command in a Adminstrator Powershell:

```powershell
$ choco install vscodium 
```
Et voilà.





