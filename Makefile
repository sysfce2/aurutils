PROGNM = aurutils
PREFIX ?= /usr/local
SHRDIR ?= $(PREFIX)/share
BINDIR ?= $(PREFIX)/bin
LIBDIR ?= $(PREFIX)/lib

.PHONY: shellcheck install

bin/aur: bin/aur.in
	m4 -DAUR_LIBDIR=$(LIBDIR)/$(PROGNM) $< >$@

shellcheck:
	@shellcheck -x lib/aur-* bin/aur

install:
	@install -Dm755 bin/aur   -t $(DESTDIR)$(BINDIR)
	@install -Dm755 lib/aur-* -t $(DESTDIR)$(LIBDIR)/$(PROGNM)
	@install -Dm644 man1/*    -t $(DESTDIR)$(SHRDIR)/man/man1
	@install -Dm644 man7/*    -t $(DESTDIR)$(SHRDIR)/man/man7
	@install -Dm644 LICENSE   -t $(DESTDIR)$(SHRDIR)/licenses/$(PROGNM)
	@install -Dm644 THANKS README.md -t $(DESTDIR)$(SHRDIR)/doc/$(PROGNM)
