{
  lib,
  stdenvNoCC,
  makeBinaryWrapper,
  nix-update-script,
  luajitPackages,
  love,
}:
stdenvNoCC.mkDerivation {
  pname = "lovix";
  version = "0.1.0";

  src = ./.;

  nativeBuildInputs = [ makeBinaryWrapper ];

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/bin"
    makeBinaryWrapper \
      ${lib.getExe love} $out/bin/lovix \
      --add-flags "$src" \
      --prefix LUA_PATH ';' "${luajitPackages.luaLib.genLuaPathAbsStr luajitPackages.fennel}"
    runHook postInstall
  '';

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Scaffold to bootstrap LÖVE projects using Nix";
    homepage = "https://github.com/cybardev/lovix";
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "lovix";
    maintainers = with lib.maintainers; [
      cybardev
    ];
  };
}
