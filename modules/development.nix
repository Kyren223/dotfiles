{ pkgs, lib, config, ... }: {

  options.development.enable = lib.mkOption {
    type        = lib.types.bool;
    default     = false;
    description = "enables development";
  };

  config = lib.mkIf config.development.enable {

    environment.systemPackages = with pkgs; [
      jetbrains.idea-community
      zed-editor
      jetbrains.clion

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
      go-tools # staticcheck
      gosec
      devtoolbox
      busybox # A bunch of utils like lsof and fuser
      cmake
      libllvm
      lld
      file

      prometheus
      grafana-loki
      grafana-alloy
      pyroscope
    ];

    # Grafana for eko
    services.grafana.enable = true;
    services.grafana.settings.server.http_port = 3030;
    services.grafana.settings.smtp.enabled = true;
    services.grafana.settings.smtp = {
      host          = "smtp.example.com:587";
      user          = "your@user.com";
      password      = "super-secret";  # Consider using a file for secret
      skip_verify   = true;
      from_address  = "your@user.com";
      from_name     = "Grafana";
      startTLS_policy = "OpportunisticStartTLS";
    };

    systemd.services.grafana = {
      serviceConfig = {
        ProtectHome = lib.mkForce false;
        ProtectSystem = lib.mkForce false;
        PrivateTmp = lib.mkForce false;
        ReadWritePaths = [ "/home/kyren/projects/eko" ];
      };
    };

    # # Allow grafana to access DB
    # fileSystems."/var/lib/grafana/eko" = {
    #   device = "/home/kyren/projects/eko";
    #   options = [ "bind" "ro" ];
    # };

    # Prometheus for eko
    services.prometheus.enable = true;
    services.prometheus.configText = builtins.readFile ./eko-prometheus.yml;

    # Alloy service for eko
    systemd.services.alloy = {
      description = "Alloy";

      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      reloadTriggers = lib.mapAttrsToList (_: v: v.source or null) (
        lib.filterAttrs (n: _: lib.hasPrefix "alloy/" n && lib.hasSuffix ".alloy" n) config.environment.etc
      );

      serviceConfig = {
        Restart = "always";
        RestartSec = "2s";

        User = "root"; # TODO: make these not root?
        Group = "root";

        SupplementaryGroups = [
          # allow to read the systemd journal for loki log forwarding
          "systemd-journal"
        ];

        ConfigurationDirectory = "alloy";
        StateDirectory = "alloy";
        WorkingDirectory = "%S/alloy";
        Type = "simple";

        ExecStart = "${lib.getExe pkgs.grafana-alloy} run /etc/alloy/";
        ExecReload = "${pkgs.coreutils}/bin/kill -SIGHUP $MAINPID";
      };
    };

    environment.etc = {
      "alloy/eko-config.alloy".text = builtins.readFile ./eko-config.alloy;
    };

    # Loki service for eko
    services.loki.enable = true;
    services.loki.configuration = {
      auth_enabled = false;

      server = {
        http_listen_port = 3100;
      };

      common = {
        ring = {
          instance_addr = "127.0.0.1";
          kvstore = {
            store = "inmemory";
          };
        };
        replication_factor = 1;
        path_prefix = "/var/lib/loki";
      };

      schema_config = {
        configs = [
          {
            from = "2020-05-15";
            store = "tsdb";
            object_store = "filesystem";
            schema = "v13";
            index = {
              prefix = "index_";
              period = "24h";
            };
          }
        ];
      };

      storage_config = {
        filesystem = {
          directory = "/var/lib/loki/chunks";
        };
      };
    };

  };
}
