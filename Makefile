PROGNM = aurutils
PREFIX ?= /usr/local
SHRDIR ?= $(PREFIX)/share
BINDIR ?= $(PREFIX)/bin

.PHONY: check install

check:
	@bash -n bin/aursift
	@bash -n bin/aurbuild
	@bash -n bin/aurbuild_chroot
	@bash -n bin/aurchain
	@bash -n bin/aurcheck
	@bash -n bin/aurfetch
	@bash -n bin/aurgrep
	@bash -n bin/aurqueue
	@bash -n bin/aursearch
	@bash -n bin/aursrcver
	@bash -n bin/aursift
	@bash -n bin/aursync

shellcheck:
	@shellcheck -x bin/*

install:
	@install -Dm755 bin/*	  -t $(DESTDIR)$(BINDIR)
	@install -Dm644 cmp/zsh/* -t $(DESTDIR)$(SHRDIR)/zsh/site-functions
	@install -Dm644 man1/*	  -t $(DESTDIR)$(SHRDIR)/man/man1
	@install -Dm644 man7/*	  -t $(DESTDIR)$(SHRDIR)/man/man7
	@install -Dm644 LICENSE	  -t $(DESTDIR)$(SHRDIR)/licenses/$(PROGNM)
	@install -Dm644 THANKS README.md -t $(DESTDIR)$(SHRDIR)/doc/$(PROGNM)
