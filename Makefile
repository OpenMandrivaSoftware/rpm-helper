PACKAGE = rpm-helper
VERSION = 0.24.18

SCRIPT_FILES = add-user del-user create-file \
	       add-service del-service reread-services \
	       add-group del-group add-shell del-shell verify-shell \
	       add-syslog del-syslog add-webapp del-webapp \
	       get-password create-ssl-certificate
MACROS_FILES = rpm-helper.macros
CONF_FILES   = ssl
TEST_FILES   = t/*.t
SYSTEMDMIGRATION_FILES = README.systemd
FILES        = AUTHORS README COPYING NEWS Makefile \
	       $(SCRIPT_FILES) $(MACROS_FILES:=.in) $(CONF_FILES) \
	       $(TEST_FILES) $(SYSTEMDMIGRATION_FILES)

pkgdatadir   = /usr/share/$(PACKAGE)
rpmmacrosdir = /usr/lib/rpm/macros.d
sysconfigdir = /etc/sysconfig
systemdmigrationdir = /var/lib/rpm-helper/systemd-migration

all:
	@echo "use make install or make dist"

install: $(MACROS_FILES)
	install -d -m 755 $(DESTDIR)$(pkgdatadir)
	cp -p $(SCRIPT_FILES) $(DESTDIR)$(pkgdatadir)
	install -d -m 755 $(DESTDIR)$(rpmmacrosdir)
	install -m 644 $(MACROS_FILES) $(DESTDIR)/$(rpmmacrosdir)/macros.rpm-helper
	install -d -m 755 $(DESTDIR)$(sysconfigdir)
	install -m 644 $(CONF_FILES) $(DESTDIR)/$(sysconfigdir)
	install -d -m 755 $(DESTDIR)$(systemdmigrationdir)
	install -m 644 $(SYSTEMDMIGRATION_FILES) $(DESTDIR)/$(systemdmigrationdir)

rpm-helper.macros: rpm-helper.macros.in
	sed -e 's:@pkgdatadir@:$(pkgdatadir):' < $< > $@

clean:
	rm -f *~

test:
	perl -I t -MExtUtils::Command::MM -e "test_harness($(TEST_VERBOSE))" $(TEST_FILES)

# rules to build a local distribution

localdist: cleandist dir localcopy tar

cleandist: clean
	rm -rf $(PACKAGE)-$(VERSION) $(PACKAGE)-$(VERSION).tar.xz

dir:
	mkdir $(PACKAGE)-$(VERSION)

localcopy:
	tar c $(FILES) | tar x -C $(PACKAGE)-$(VERSION)

tar:
	tar cavf $(PACKAGE)-$(VERSION).tar.xz $(PACKAGE)-$(VERSION)
	rm -rf $(PACKAGE)-$(VERSION)

# rules to build a public distribution

dist: cleandist dir localcopy tar gittag

gittag:
	git tag -f v$(VERSION)
