#############################################################################
# Project         : Mandrake Linux
# Module          : rpm-helper
# File            : rpm-helper.spec
# Version         : $Id$
# Author          : Frederic Lepied
# Created On      : Tue Jul  9 08:21:29 2002
# Purpose         : rpm build rules
#############################################################################

Summary: Helper scripts for rpm scriptlets
Name: rpm-helper
Version: 0.5
Release: 1mdk
Source0: %{name}-%{version}.tar.bz2
License: GPL
Group: System/Configuration/Packaging
URL: http://www.mandrakelinux.com/
BuildArchitectures: noarch
BuildRoot: %{_tmppath}/%{name}-buildroot
Prefix: %{_prefix}

%description
Helper scripts for rpm scriptlets to help create/remove services/users.

%prep
%setup

%build

%install
rm -rf $RPM_BUILD_ROOT
%makeinstall_std LIBDIR=%{_datadir}/%{name}

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root)
%doc README* ChangeLog AUTHORS
%{_datadir}/%{name}

%changelog
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
