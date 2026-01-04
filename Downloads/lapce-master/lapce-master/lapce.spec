Name:           aurion-ide-git
Version:        0.4.5.{{{ git_dir_version }}}
Release:        1
Summary:        Lightning-fast and Powerful Code Editor written in Rust
License:        Apache-2.0
URL:            https://github.com/aurion-ide/aurion-ide

VCS:            {{{ git_dir_vcs }}}
Source:        	{{{ git_dir_pack }}}

BuildRequires:  cargo libxkbcommon-x11-devel libxcb-devel vulkan-loader-devel wayland-devel openssl-devel pkgconf libxkbcommon-x11-devel

%description
Aurion IDE is written in pure Rust, with a UI in Floem (also written in Rust).
It is designed with Rope Science from the Xi-Editor, enabling lightning-fast computation, and leverages wgpu for rendering.

%prep
{{{ git_dir_setup_macro }}}
cargo fetch --locked

%build
cargo build --profile release-lto --package aurion-ide-app --frozen

%install
install -Dm755 target/release-lto/aurion-ide %{buildroot}%{_bindir}/aurion-ide
install -Dm644 extra/linux/dev.aurion-ide.aurion-ide.desktop %{buildroot}/usr/share/applications/dev.aurion-ide.aurion-ide.desktop
install -Dm644 extra/linux/dev.aurion-ide.aurion-ide.metainfo.xml %{buildroot}/usr/share/metainfo/dev.aurion-ide.aurion-ide.metainfo.xml
install -Dm644 extra/images/logo.png %{buildroot}/usr/share/pixmaps/dev.aurion-ide.aurion-ide.png

%files
%license LICENSE*
%doc *.md
%{_bindir}/aurion-ide
/usr/share/applications/dev.aurion-ide.aurion-ide.desktop
/usr/share/metainfo/dev.aurion-ide.aurion-ide.metainfo.xml
/usr/share/pixmaps/dev.aurion-ide.aurion-ide.png

%changelog
* Mon Jan 01 2024 Jakub Panek
- See full changelog on GitHub



