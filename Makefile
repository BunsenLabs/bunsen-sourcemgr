# Makefile for building and installing man pages
# Copyright (C) 2015 Jens John <dev@2ion.de>
# Licensed under the GNU General Public License v3+

MANPAGE_SOURCES = apt-sourcemgr.1.mkd
MANPAGE_TARGETS = $(patsubst %.mkd,%.gz,$(MANPAGE_SOURCES))

mancat = $(subst .,,$(suffix $(patsubst %.gz,%,$(1))))

all: $(MANPAGE_SOURCES) $(MANPAGE_TARGETS)

apt-sourcemgr.1.mkd: README.md
	cp $< $@

%.gz: %.mkd
	$(info PANDOC $<)
	@pandoc -s -f markdown+pipe_tables -t man -o $(@:.gz=) $<
	$(info GZIP $(@:.gz=))
	@gzip -f9 $(@:.gz=)

clean:
	@rm -f -- $(MANPAGE_SOURCES) $(MANPAGE_TARGETS)
	@echo Clean.

install: $(MANPAGE_TARGETS)
	$(foreach m,$^,$(shell install -Dm644 $(m) $(DESTDIR)$(PREFIX)/usr/share/man/man$(call mancat,$(m))/$(m)))

