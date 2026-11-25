# RPM spec for GraveLauncher.
# Packages an already-built, stripped binary; invoked from scripts/build_linux.sh:
#   rpmbuild -bb package/linux/grave-launcher.spec --define "_gl_version <ver>" --define "_gl_root <repo root>" --define "_gl_binary <path to binary>"

%define debug_package %{nil}
%global __os_install_post %{nil}

Name:           grave-launcher
Version:        %{_gl_version}
Release:        1
Summary:        A modern Minecraft launcher
License:        MIT
URL:            https://github.com/amardeeplakshkar/GraveLauncher
ExclusiveArch:  x86_64

%description
GraveLauncher is a modern Minecraft launcher that balances ease-of-use with
powerful instance management features. Forked from Pandora Launcher by Moulberry.

%install
install -Dm755 %{_gl_binary} %{buildroot}%{_bindir}/grave-launcher
install -Dm644 %{_gl_root}/package/linux/io.github.amardeeplakshkar.GraveLauncher.desktop %{buildroot}%{_datadir}/applications/io.github.amardeeplakshkar.GraveLauncher.desktop
for size in 16 32 48 256; do
    install -Dm644 %{_gl_root}/package/windows_icons/icon_${size}x${size}.png %{buildroot}%{_datadir}/icons/hicolor/${size}x${size}/apps/io.github.amardeeplakshkar.GraveLauncher.png
done
install -Dm644 %{_gl_root}/LICENSE %{buildroot}%{_datadir}/licenses/grave-launcher/LICENSE

%files
%{_bindir}/grave-launcher
%{_datadir}/applications/io.github.amardeeplakshkar.GraveLauncher.desktop
%{_datadir}/icons/hicolor/*/apps/io.github.amardeeplakshkar.GraveLauncher.png
%{_datadir}/licenses/grave-launcher/LICENSE
