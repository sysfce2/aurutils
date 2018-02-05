PROGNM = aurutils
PREFIX ?= /usr/local
SHRDIR ?= $(PREFIX)/share
BINDIR ?= $(PREFIX)/bin
LIBDIR ?= $(PREFIX)/lib

.PHONY: shellcheck install

shellcheck:
	@shellcheck -x lib/* bin/*

install:
	@install -Dm755 bin/*   -t $(DESTDIR)$(BINDIR)
	@install -Dm755 lib/*   -t $(DESTDIR)$(LIBDIR)/$(PROGNM)
	@install -Dm644 man1/*  -t $(DESTDIR)$(SHRDIR)/man/man1
	@install -Dm644 man7/*  -t $(DESTDIR)$(SHRDIR)/man/man7
	@install -Dm644 LICENSE -t $(DESTDIR)$(SHRDIR)/licenses/$(PROGNM)
	@install -Dm644 THANKS README.md -t $(DESTDIR)$(SHRDIR)/doc/$(PROGNM)
