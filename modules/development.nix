{ pkgs, lib, config, ... }: {

  options.development.enable = lib.mkOption {
    type        = lib.types.bool;
    default     = false;
    description = "enables development";
  };

  config = lib.mkIf config.development.enable {

    environment.systemPackages = with pkgs; [
      jetbrains.idea-community

      # LSP
      asm-lsp
      astro-language-server
      basedpyright
      bash-language-server
      vscode-langservers-extracted # html/css/json
      gopls
      lemminx # xml
      lua-language-server
      markdown-oxide
      marksman
      mdx-language-server
      neocmakelsp
      nil # nix
      tailwindcss-language-server
      taplo # toml
      typescript-language-server
      yaml-language-server
      # pnpm i -g css-variables-language-server
      # pnpm install -g gh-actions-language-server
      jdt-language-server
      kotlin-language-server

      # Tools
      stylua
      gofumpt
      golangci-lint
      prettierd
      jq
      lldb # codelldb debugger
      shellcheck
      beautysh # shell formatter
      gdb
      nasm
      rustup
      tokei # count lines of code
      go
      pnpm
      nodejs_24
      clang
      clang-tools
      gcc
      gnumake
      goose
      sqlc
      maven
      gradle
      kotlin
      mold # fast linker, for rust
      gomodifytags
      sops
    ];

  };
}
