{ lib
, stdenv
, fetchFromGitHub
, makeWrapper
, instantAssist
, instantConf
, instantUtils
, instantWallpaper
, arandr
, arc-theme
, autorandr
, bc
, blueman
, firaCodeNerd
, gnome-disk-utility
, gufw
, hicolor-icon-theme
, lxappearance
, neovim
, papirus-icon-theme
, pavucontrol
, st
, system-config-printer
, udiskie
, xfce4-power-manager
, gnome3
}:
let
  utilities = [
    instantAssist
    instantUtils
    instantConf
    instantWallpaper
    arandr
    autorandr
    bc
    blueman
    gnome-disk-utility
    gufw
    lxappearance
    neovim
    pavucontrol
    st
    system-config-printer
    udiskie
    xfce4-power-manager
    firaCodeNerd
    papirus-icon-theme
    arc-theme
    hicolor-icon-theme
    gnome3.zenity
  ];
in
stdenv.mkDerivation {

  pname = "instantSettings";
  version = "unstable";

  src = fetchFromGitHub {
    owner = "instantOS";
    repo = "instantSETTINGS";
    rev = "61e7d620b064105fd845a527af38a1bdb96331bd";
    sha256 = "hLKfpkxVBY0Ybn7dz9Lx7ckI5LzJLIq3E+Iaatr7+4o=";
  };
  # src = ../../src/instantsettings;

  nativeBuildInputs = [ makeWrapper ];

  propagatedBuildInputs = utilities;

  makeFlags = [ "PREFIX=$(out)/" ];

  postPatch = ''
    substituteInPlace settings.sh \
      --replace "/usr/share/instantassist" "${instantAssist}/share/instantassist" \
      --replace "/usr/share/instantsettings" "$out/share/instantsettings"
  '';

  installPhase = ''
    make install PREFIX=$out/
    ln -s "$out/bin/instantsettings" "$out/bin/instantos-control-center"
    runHook postInstall
  '';

  postInstall = ''
    wrapProgram "$out/bin/instantsettings" \
      --prefix PATH : ${lib.makeBinPath utilities}
  '';

  meta = with lib; {
    description = "Simple settings app for instant-OS";
    license = licenses.gpl2;
    homepage = "https://github.com/instantOS/instantSETTINGS";
    maintainers = [ "Scott Hamilton <sgn.hamilton+nixpkgs@protonmail.com>" ];
    platforms = platforms.linux;
  };
}
