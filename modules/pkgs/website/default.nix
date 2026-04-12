# feature: Zola blog website package with devShells and NixOS modules
{self, ...}: {
  perSystem = {
    lib,
    pkgs,
    ...
  }: {
    packages.website = pkgs.stdenv.mkDerivation {
      pname = "zola-website";
      version = "0.1.0";

      src = ./.;

      nativeBuildInputs = [pkgs.zola];

      zolaTheme = pkgs.fetchFromGitHub {
        owner = "lopes";
        repo = "zola.386";
        rev = "master";
        hash = "sha256-pmlgG7cS7daJek8U+Epb1Flo4mOESyudiAQDv9YyHRQ=";
      };

      preBuild = ''
        mkdir -p themes/zola.386
        cp -r $zolaTheme/* themes/zola.386/
        chmod -R +w themes/zola.386
      '';

      buildPhase = ''
        runHook preBuild
        zola build -o $out
      '';

      meta = with lib; {
        description = "Retro Zola blog";
        homepage = "https://air1.one";
        license = licenses.mit;
        maintainers = [];
      };
    };

    # Does not contain the website package, just a basic shell so I can use it
    # in watch mode to edit the website on the fly
    devShells.website = pkgs.mkShell {
      buildInputs = [pkgs.zola];

      shellHook = ''
        THEME_DIR="pkgs/website/themes/zola.386"
        if [ ! -d "$THEME_DIR" ]; then
          mkdir -p pkgs/website/themes
          git clone https://github.com/lopes/zola.386 "$THEME_DIR"
        fi

        echo "To locally test the website, run:"
        echo "$ cd pkgs/website && zola serve"
      '';
    };
  };

  flake.nixosModules.website = {
    lib,
    pkgs,
    config,
    ...
  }: {
    options.stars.server.website.enable =
      lib.mkEnableOption "the blog";

    config = lib.mkIf config.stars.website.enable {
      services = {
        # NGINX is probably overkill for serving static files
        # TODO: find a better way
        nginx = {
          enable = true;
          virtualHosts."_" = {
            listen = [
              {
                addr = "127.0.0.1";
                port = 5972;
              }
            ];
            root = self.packages.${pkgs.stdenv.hostPlatform.system}.website;
            locations."/".extraConfig = ''
              autoindex off;
              try_files $uri $uri/index.html $uri.html =404;
            '';
          };
        };

        anubis.instances.mainsite = lib.mkIf config.stars.server.anubis.enable {
          enable = true;
          settings = {
            TARGET = "http://127.0.0.1:5972";
            ED25519_PRIVATE_KEY_HEX_FILE = config.sops.secrets."anubis/mainsite_key".path;
            BIND_NETWORK = "tcp";
            BIND = ":3032";
          };
        };

        traefik.dynamicConfigOptions.http = lib.mkIf config.stars.server.traefik.enable {
          routers.mainsite = {
            rule = "Host(`air1.one`)";
            service = "mainsite";
            entryPoints = ["websecure"];
            tls.certResolver = "le";
          };
          services.mainsite.loadBalancer.servers = [
            {url = "http://127.0.0.1:3032";}
          ];
        };
      };
    };
  };
}
