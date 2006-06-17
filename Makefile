#############################################################################
# Project       : Mandriva Linux
# File		: Makefile
# Package	: rpm-helper
# Author	: Frederic Lepied
# Created on	: Mon Sep 30 13:20:18 1999
# Version	: $Id$
# Purpose	: rules to manage the files.
#############################################################################

PACKAGE = rpm-helper
VERSION := $(shell rpm -q --qf %{VERSION} --specfile $(PACKAGE).spec)
RELEASE := $(shell rpm -q --qf %{RELEASE} --specfile $(PACKAGE).spec)
TAG := $(shell echo "V$(VERSION)_$(RELEASE)" | tr -- '-.' '__')

FILES = AUTHORS README README.CVS COPYING ChangeLog Makefile \
       $(PACKAGE).spec $(SCRIPTS) $(MACROFILEIN)
SCRIPTS = add-user del-user add-service del-service create-file \
	add-group del-group add-shell del-shell verify-shell \
	add-syslog del-syslog add-webapp del-webapp

LIBDIR=/usr/share/$(PACKAGE)
RPMACROSDIR=/etc/rpm/macros.d

MACROFILEIN = $(PACKAGE).macros.in
MACROFILE = $(MACROFILEIN:.in=)

RPMOPT = --clean --rmsource --rmspec

all:
	@echo "done"

clean:
	rm -f *~ $(PACKAGE)*.tar.bz2

install:
	-mkdir -p $(DESTDIR)$(LIBDIR)
	cp -p $(SCRIPTS) $(DESTDIR)$(LIBDIR)
	-mkdir -p $(DESTDIR)$(RPMACROSDIR)
	cat $(MACROFILEIN) | \
	sed 's,@LIBDIR@,$(LIBDIR),g' > $(DESTDIR)$(RPMACROSDIR)/$(MACROFILE)

version:
	@echo "$(VERSION)-$(RELEASE)"

# rules to build a test rpm

localrpm: localdist buildrpm

localsrpm: localdist buildsrpm

localdist: cleandist dir localcopy tar

cleandist:
	rm -rf $(PACKAGE)-$(VERSION) $(PACKAGE)-$(VERSION).tar.bz2

dir:
	mkdir $(PACKAGE)-$(VERSION)

localcopy:
	tar c $(FILES) | tar x -C $(PACKAGE)-$(VERSION)

tar:
	tar cvf $(PACKAGE)-$(VERSION).tar $(PACKAGE)-$(VERSION)
	bzip2 -9vf $(PACKAGE)-$(VERSION).tar
	rm -rf $(PACKAGE)-$(VERSION)

buildrpm:
	rpm -ta $(RPMOPT) $(PACKAGE)-$(VERSION).tar.bz2

buildsrpm:
	rpm -ts $(RPMOPT) $(PACKAGE)-$(VERSION).tar.bz2

# rules to build a distributable rpm

rpm: changelog dist buildrpm

dist: cleandist dir tar

changelog:
	svn2cl -o ChangeLog 
	rm -f ChangeLog.bak
	svn commit -m "Generated by svn2cl" ChangeLog

# Makefile ends here
