#############################################################################
# Project         : Mandriva Linux
# Module          : rpm-helper
# File            : rpm-helper.spec
# Version         : $Id$
# Author          : Frederic Lepied
# Created On      : Tue Jul  9 08:21:29 2002
# Purpose         : rpm build rules
#############################################################################

Summary: Helper scripts for rpm scriptlets
Name: rpm-helper
Version: 0.15
Release: %mkrel 1
Source0: %name-%version.tar.bz2
License: GPL
Group: System/Configuration/Packaging
URL: http://www.mandrivalinux.com/
BuildArch: noarch
BuildRoot: %_tmppath/%name-buildroot
Conflicts: chkconfig < 1.3.4-10mdk
Requires: grep, shadow-utils, chkconfig, coreutils

%description
Helper scripts for rpm scriptlets to help create/remove :
- groups
- services
- shells
- users

%prep
%setup

%build

%install
rm -rf $RPM_BUILD_ROOT
%makeinstall_std LIBDIR=%_datadir/%name

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root)
%doc README* ChangeLog AUTHORS
%_datadir/%name
%_sys_macros_dir/%name.macros

%changelog
* Thu Feb 09 2006 Rafael Garcia-Suarez <rgarciasuarez@mandriva.com> 0.15-1mdk
- add-service: handle case when a service name appears several times.

* Tue Sep 20 2005 Frederic Lepied <flepied@mandriva.com> 0.14-1mdk
- add-service: don't add the service to all the profiles in upgrade mode.

* Sat Sep 10 2005 Frederic Lepied <flepied@mandriva.com> 0.13-1mdk
- add-service: test /etc/security/msec/server wihout taking care of
  $SECURE_LEVEL (bug #18409).
- add-service:  add by default the service to all the profiles if
  ADD_SERVICES_TO_CURRENT_PROFILE_ONLY isn't set in
  /etc/sysconfig/system.

* Wed Aug 03 2005 Herton Ronaldo Krzesinski <herton@mandriva.com> 0.12-1mdk
- Version bump: new version that contais syslog helpers

* Thu Jun 30 2005 Olivier Thauvin <nanardon@mandriva.org> 0.11-1mdk
- provide itself its macro (rpm 4.4 powah)
- mkrel

* Thu Sep 23 2004 Frederic Lepied <flepied@mandrakesoft.com> 0.10-1mdk
- add-service: add the service again on upgrade if the service is activated

* Wed Sep 17 2003 Frederic Lepied <flepied@mandrakesoft.com> 0.9.1-1mdk
- don't depend on initscripts anymore

* Tue Jan 14 2003 Frederic Lepied <flepied@mandrakesoft.com> 0.9-1mdk
- added the right requires

* Sun Dec 22 2002 Frederic Lepied <flepied@mandrakesoft.com> 0.8-1mdk
- corrected add-shell to not add the shell multiple times
- corrected add-service when SECURE_LEVEL isn't set
- corrected add-group not to delete supplementary groups already added

* Tue Nov  5 2002 Thierry Vignaud <tvignaud@mandrakesoft.com> 0.7.1-1mdk
- add verify-shell

* Tue Nov  5 2002 Thierry Vignaud <tvignaud@mandrakesoft.com> 0.7-1mdk
- add add-shell and del-shell to update /etc/shells

* Fri Sep  6 2002 Frederic Lepied <flepied@mandrakesoft.com> 0.6-1mdk
- add add-shell and del-shell to update /etc/shells
- add-service: do the security stuff here instead of doing it in chkconfig
to be more flexible.

* Thu Aug  1 2002 Frederic Lepied <flepied@mandrakesoft.com> 0.5-1mdk
- add-service: on upgrade, restart services that depend of portmap.

* Wed Jul 31 2002 Frederic Lepied <flepied@mandrakesoft.com> 0.4.1-1mdk
- correct add-group when no user is added to the group

* Mon Jul 29 2002 Frederic Lepied <flepied@mandrakesoft.com> 0.4-1mdk
- added del-group and add-group

* Fri Jul 12 2002 Frederic Lepied <flepied@mandrakesoft.com> 0.3-1mdk
- extend add-user to support extended groups

* Wed Jul 10 2002 Frederic Lepied <flepied@mandrakesoft.com> 0.2-1mdk
- added create-file

* Tue Jul  9 2002 Frederic Lepied <flepied@mandrakesoft.com> 0.1-1mdk
- Initial version

# end of file
