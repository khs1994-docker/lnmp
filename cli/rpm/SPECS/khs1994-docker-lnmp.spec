Name:       khs1994-docker-lnmp
Version:    KHS1994_DOCKER_LNMP_VERSION
Release:    1.el7.centos
Summary:    Start LNMP In less than 2 minutes Powered by Docker Compose.

License:    Apache-2.0
URL:        https://github.com/khs1994-docker/lnmp

# BuildRequires:
Requires:   git

%description
Start LNMP In less than 2 minutes Powered by Docker Compose.

%pre
%post
cd /data/lnmp
bash lnmp-docker
%preun
%build
%install
rm -rf %{buildroot}
git clone -b v%{version} --depth=1 --recursive https://github.com/khs1994-docker/lnmp.git %{buildroot}/data/lnmp
rm -rf %{buildroot}/data/lnmp/.git
%files
%defattr (-,root,root,-)
/data/lnmp
%changelog
%clean
RPM_NAME=khs1994-docker-lnmp-%{version}-%{release}.x86_64.rpm
cp -a %{buildroot}/../../RPMS/x86_64/${RPM_NAME} ~
