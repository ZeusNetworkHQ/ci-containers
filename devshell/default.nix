{ pkgs
, ...
}:


pkgs.mkShell {
  name = "dev-shell";

  nativeBuildInputs = with pkgs; [
    tokei

    jq

    hclfmt
    nixpkgs-fmt
    nodePackages.prettier
    shfmt
    taplo
    treefmt

    shellcheck
  ];

  shellHook = ''
    export NIX_PATH="nixpkgs=${pkgs.path}"
  '';
}
