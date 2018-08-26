PROGNM = aurutils
PREFIX ?= /usr
SHRDIR ?= $(PREFIX)/share
BINDIR ?= $(PREFIX)/bin
LIBDIR ?= $(PREFIX)/lib

.PHONY: shellcheck install

aur: aur.in
	m4 -DAUR_LIB_DIR=$(LIBDIR)/$(PROGNM) $< >$@

shellcheck: aur
	@shellcheck -x -f gcc -e 2035,2086,2094,2016,1117,1083,1071 aur lib/*

install:
	@install -Dm755 aur       -t $(DESTDIR)$(BINDIR)
	@install -Dm755 contrib/* -t $(DESTDIR)$(SHRDIR)/$(PROGNM)/contrib
	@install -Dm755 lib/aur-* -t $(DESTDIR)$(LIBDIR)/$(PROGNM)
	@install -Dm644 man1/*    -t $(DESTDIR)$(SHRDIR)/man/man1
	@install -Dm644 man7/*    -t $(DESTDIR)$(SHRDIR)/man/man7
	@install -Dm644 LICENSE   -t $(DESTDIR)$(SHRDIR)/licenses/$(PROGNM)
