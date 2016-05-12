PROGNM = aurutils
PREFIX ?= /usr/local
SHRDIR ?= $(DESTDIR)$(PREFIX)/share
BINDIR ?= $(DESTDIR)$(PREFIX)/bin

.PHONY: check install

check:
	@shellcheck -e 2016 -x bin/*

install:
	@install -Dm755 bin/*	       -t $(BINDIR)
	@install -Dm644 cmp/zsh/*      -t $(SHRDIR)/zsh/site-functions
	@install -Dm644 man1/*	       -t $(SHRDIR)/man/man1
	@install -Dm644 man7/*	       -t $(SHRDIR)/man/man7
	@install -Dm644 LICENSE	       -t $(SHRDIR)/licenses/$(PROGNM)
	@install -Dm644 CREDITS README -t $(SHRDIR)/doc/$(PROGNM)
