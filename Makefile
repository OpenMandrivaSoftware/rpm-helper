PACKAGE = rpm-helper
VERSION = 0.20.0
SVNPATH = svn+ssh://svn.mandriva.com/svn/soft/rpm/$(PACKAGE)

SCRIPT_FILES = add-user del-user add-service del-service create-file \
	       add-group del-group add-shell del-shell verify-shell \
	       add-syslog del-syslog add-webapp del-webapp \
	       get-password create-ssl-certificate
MACROS_FILES = rpm-helper.macros
CONF_FILES   = ssl
FILES        = AUTHORS README COPYING NEWS Makefile \
               $(SCRIPT_FILES) $(MACROS_FILES:=.in) $(CONF_FILES)

pkgdatadir   = /usr/share/$(PACKAGE)
rpmmacrosdir = /etc/rpm/macros.d
sysconfigdir = /etc/sysconfig

all:
	@echo "use make install or make dist"

install: $(MACROS_FILES)
	install -d -m 755 $(DESTDIR)$(pkgdatadir)
	cp -p $(SCRIPT_FILES) $(DESTDIR)$(pkgdatadir)
	install -d -m 755 $(DESTDIR)$(rpmmacrosdir)
	install -m 644 $(MACROS_FILES) $(DESTDIR)/$(rpmmacrosdir)
	install -d -m 755 $(DESTDIR)$(sysconfigdir)
	install -m 644 $(CONF_FILES) $(DESTDIR)/$(sysconfigdir)

rpm-helper.macros: rpm-helper.macros.in
	sed -e 's:@pkgdatadir@:$(pkgdatadir):' < $< > $@

clean:
	rm -f *~

# rules to build a local distribution

localdist: cleandist dir localcopy tar

cleandist: clean
	rm -rf $(PACKAGE)-$(VERSION) $(PACKAGE)-$(VERSION).tar.bz2

dir:
	mkdir $(PACKAGE)-$(VERSION)

localcopy:
	tar c $(FILES) | tar x -C $(PACKAGE)-$(VERSION)

tar:
	tar cvf $(PACKAGE)-$(VERSION).tar $(PACKAGE)-$(VERSION)
	bzip2 -9vf $(PACKAGE)-$(VERSION).tar
	rm -rf $(PACKAGE)-$(VERSION)

# rules to build a public distribution

dist: cleandist dir localcopy tar svntag

svntag:
	svn cp -m 'version $(VERSION)' $(SVNPATH)/trunk $(SVNPATH)/tags/v$(VERSION)
