---
layout: post
title: "Publishing a private wiki without leaking it"
date:   2026-11-02 18:00:00 +0100
categories: blog workflow privacy
---

For a couple of years I have kept a personal wiki about the machines I own: hardware datasheets,
Windows and Linux handbooks, driver archives, PowerShell scripts, troubleshooting notes. It lives in
a local git repository and it is *useful precisely because it is private*: links point to real
files on disk, so clicking a driver in the handbook opens the installer that sits right next to it,
and the datasheets contain serials, hostnames and MAC addresses I need when something breaks.

At the same time most of that knowledge is worth sharing. So I wanted a second, **public** copy of
the wiki here on the blog, without maintaining two versions by hand and without ever publishing
something I should not. This post describes the workflow I ended up with, built together with
[Claude Code](https://code.claude.com) as a pair programmer.

You can see the result in the [Wiki](/wiki/) section of this site.

## The requirements

Before writing any code I wrote down what the pipeline had to guarantee:

1. **The private wiki stays the single source of truth.** The public copy is generated, never
   edited by hand.
2. **Only committed content is published.** Drafts and scratch files never leave my machine.
3. **Personal data is redacted** — and a leak must be *impossible to commit*, not just unlikely.
4. **Every link keeps working.** A link to a local driver becomes a link to the vendor's official
   download page. Never "available locally only".
5. **No lock-in to Jekyll.** I am fairly sure I will move this site to another generator soon, so
   the tooling is plain Bash and coreutils: no Python, no Ruby outside the test container.
6. **A human approves every publication**, and it is tested locally before it goes online.

## The big picture

```
private wiki (local git)                         website repo (GitHub Pages)
├─ machine_fleet.md, operating_systems.md        ├─ _config.yml
├─ fleet/<machine>/   datasheets + drivers       └─ wiki/   ← generated, never by hand
├─ os/windows/, os/linux/   handbooks + scripts
├─ selfhost/
├─ .publishignore      what never goes online
├─ .wiki/              redaction rules, vendor links
└─ tools/              export, leak check, ship
```

The flow has two halves, each one a Claude Code *skill* (a written procedure the agent follows):

- **`/wiki-write`** — I direct, the agent writes: new pages, edits, scripts. It runs the tests and
  commits to the private repository.
- **`/wiki-publish`** — from the committed wiki to the website: export, redaction, privacy review,
  my approval, local test, commit and push.

## Step 1: writing and testing

Content changes follow a few conventions: one folder per machine under `fleet/`, one per OS family
under `os/`, link texts are page titles (never `something.md`). When a page links a new binary —
a driver, a BIOS package, an installer — the vendor's download URL has to be added to a small
mapping file, otherwise the export refuses to run.

The PowerShell scripts in the wiki are linted with PSScriptAnalyzer and covered by
[Pester](https://pester.dev) tests. The tests never touch the system: everything that would change
the registry, Bluetooth pairings or installed apps is mocked.

## Step 2: export

`wiki_export.sh` reads the repository **at `HEAD`** (`git ls-tree` + `git show`), not the working
tree, so uncommitted edits cannot sneak in. It then:

- drops everything listed in `.publishignore` (gitignore syntax: tooling, agent instructions,
  workflow notes, tests);
- copies text files (Markdown, scripts, JSON) and **never** copies binaries;
- rewrites links: Markdown links stay relative, a link to a binary is replaced with the vendor URL
  from `.wiki/links.tsv`, a link to a folder points to that folder's index page;
- **fails** — exit code 3 and a list of offending links — if a local link points to something that
  is neither published nor mapped.

Failing closed is the important part. There is no fallback text, no silent removal: either a link
has a public target or the export stops and tells me which one to fix.

The output is neutral Markdown. A tiny *adapter* turns it into what Jekyll expects: front matter
with the page title, and a Liquid `raw` block around the content so PowerShell code is not
interpreted as template syntax. Moving to another generator means writing another adapter of
about forty lines.

## Step 3: redaction on three levels

**1. Deterministic.** Two kinds of rules, both applied with `sed -E` and case-insensitive:

```
# .wiki/redact.patterns — families of values (name, regex, optional replacement)
uuid           \{?[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\}?
mac            \b([0-9a-f]{2}[:-]){5}[0-9a-f]{2}\b
serial-inline  (serial:? +)[a-z0-9]{6,}            \1[REDACTED]
win-user-path  (c:(\\|/)+users(\\|/)+)[[:alnum:]._-]+   \1[REDACTED]

# .wiki/denylist.local — exact private values, one per line (gitignored)
my-hostname
ABC123SERIAL
```

The denylist is never committed and never exported. Its sibling, `allow.list`, keeps public values
that look private: a well-known Windows CLSID, a vendor support address.

**2. Semantic.** Regular expressions do not understand context, so after the export a dedicated
sub-agent reads the redacted output looking for what the rules missed: names of people, network
details, habits, locations. It does not edit anything. It proposes new rules, I accept or reject
them, and the export runs again. The result stays reproducible: the same commit and the same rules
always produce the same public wiki.

**3. The gate.** `wiki_leakcheck.sh` scans the output (and later the built HTML) for any denylist
value or pattern match and exits non-zero if it finds one. It also runs as a **pre-commit hook**
in the website repository: even a manual `git commit` of a leaky page is refused.

## Step 4: my review

Before anything touches the website history I get a summary: pages added, changed and removed,
how many values were redacted per page and by which rule, which links now point to vendors. I can
open any page. Nothing moves on until I say so.

## Step 5: local test with podman

GitHub Pages builds this site with the `github-pages` gem, which pins Jekyll 3.10 and turns on a
set of plugins by default — `jekyll-relative-links` among them, which converts `.md` links into
page URLs. My own `Gemfile` is much older, so testing with it would prove nothing.

So the test runs in a container, under Debian in WSL, with exactly the gems Pages uses:

```bash
podman build -t wiki-site -f tools/site/Containerfile tools/site
podman run --rm -v "$SITE_REPO":/site wiki-site wiki-site-test
```

`wiki-site-test` builds the site and runs [html-proofer](https://github.com/gjtorikian/html-proofer)
on the generated wiki: broken internal links, missing anchors, missing images. The leak check runs
once more on the built HTML. Finally the agent starts `jekyll serve` in the same container and
opens the pages in a browser so I can look at them.

The local test paid off on day one: every table on the hardware datasheet rendered as a wall of
pipes. The culprit was [kramdown](https://kramdown.gettalong.org/), the Ruby library Jekyll uses by
default to convert Markdown into HTML, and the one this site is configured with. Unlike GitHub's
renderer, it only recognises a table when a blank line precedes it, and my pages put tables right
under the headings. The adapter now inserts that blank line, and a test makes sure it keeps doing
so.

## Step 6: shipping

`wiki_ship.sh` stages the generated `wiki/` folder, runs the leak check one last time and only
then commits and pushes. If anything is off, it does nothing and writes a log.

Commits follow [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/), keep the
casing already used in each repository, and are authored by me. The website side uses a feature
branch, so nothing reaches the published branch without a merge.

## Testing the tools themselves

The Bash tools have their own suite written with [bats](https://github.com/bats-core/bats-core).
Each test builds a throw-away git repository with every awkward case I could think of: links with
spaces, anchors and titles, a link inside a code block, an ignored page, an untracked page, an
unmapped binary, a UUID, a MAC address, a Windows user path, an allow-listed CLSID. Then it checks
the export, the leak check, the Jekyll adapter and the ship script against a local bare remote.

## Things I learned along the way

- **`wsl.exe -- bash -c '...$VAR...'` is a trap.** Without `--exec`, the command line goes through
  the default shell first, which expands `$VAR` before your `bash -c` ever sees it.
- **Line endings matter across two gits.** A repository cloned by Git for Windows looks fully
  modified to git in WSL. Setting `core.autocrlf` in the repository config made both agree.
- **Fail closed, everywhere.** The first real export failed because the project's instruction file
  for the agent was now tracked and would have been published. The pipeline stopped, I added one
  line to `.publishignore`, and nothing leaked. That failure was the most reassuring moment of the
  whole project.
- **Keep formats boring.** Tab-separated files and one-rule-per-line lists can be read with `awk`
  and `grep` alone, and that is what keeps the tooling portable to whatever replaces Jekyll here.

## What's next

The next step is the one I mentioned in my
[previous post]({% post_url 2023-01-01-change-blogging-style %}): moving this site off Jekyll.
With the export separated from the generator, that should mean writing one new adapter and
nothing else.
