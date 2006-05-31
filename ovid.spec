%define _unpackaged_files_terminate_build 0
Summary: Ovid 
Name: ovid 
Version: 0.11
Release: 1
Copyright: distributable
Group: Applications/CPAN
Source: Ovid-%{version}.tar.gz 
BuildRoot: /tmp/Ovid
Packager: Gyepi Sam <gyepi@praxis-sw.com>
AutoReq: no
AutoReqProv: no
Requires: perl(Exporter)
Requires: perl(File::Basename)
Requires: perl(POSIX)
Requires: perl(strict)
Provides: perl(Ovid::Common)
Provides: perl(Ovid::Dependency)
Provides: perl(Ovid::Error)
Provides: perl(Ovid::Package)

%description
Ovid recursively builds CPAN modules and all dependent modules as RPM files.  

%prep
%setup -q -n Ovid-%{version} 

%build
CFLAGS="$RPM_OPT_FLAGS" perl Makefile.PL
make

%clean 
rm -rf $RPM_BUILD_ROOT

%install
rm -rf $RPM_BUILD_ROOT

make PREFIX=%{_prefix} \
     DESTDIR=${RPM_BUILD_ROOT}/ \
     install

[ -x /usr/lib/rpm/brp-compress ] && /usr/lib/rpm/brp-compress

find ${RPM_BUILD_ROOT} \
  \( -path '*/perllocal.pod' -o -path '*/.packlist' -o -path '*.bs' \) -a -prune -o \
  -type f -printf "/%%P\n" > Ovid-filelist

if [ "$(cat Ovid-filelist)X" = "X" ] ; then
    echo "ERROR: EMPTY FILE LIST"
    exit 1
fi

%files -f Ovid-filelist
%defattr(-,root,root)
%doc Changes Makefile.PL MANIFEST README TODO


%changelog
* Mon Mar 21 2005 Gyepi Sam <gyepi@praxis-sw.com>
-Changed PERL_INSTALL_ROOT to DESTDIR to make newer ExtUtils::MakeMaker behave correctly.
-Omit *.bs files from rpm list.
* Sun Aug 15 2004 Gyepi Sam <gyepi@praxis-sw.com>
- Initial build