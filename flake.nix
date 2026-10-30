{
  description = "MoguchOS";

  inputs = {
    #nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    #nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    #nixpkgs.url = "https://channels.nixos.org/nixpkgs-unstable/nixexprs.tar.xz";
    #nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable-small";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      #url = "github:nix-community/home-manager/release-25.05";
      #url = "github:nix-community/home-manager/master";
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    #hyprland.url = "github:hyprwm/Hyprland";
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    fine-cmdline = {
      url = "github:VonHeikemen/fine-cmdline.nvim";
      flake = false;
    };
    #nix-proton-cachyos.url = "github:kimjongbing/nix-proton-cachyos";
    /*pyprland = {
      url = "github:hyprland-community/pyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    durdraw = {
      url = "github:scottmckendry/durdraw/nix-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprpanel = {
      url = "github:Jas-SinghFSU/HyprPanel";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprsettings = {
      url = "github:wiktormalyska/hyprsettings-nixos";
      inputs.nixpkgs.follows = "nixpkgs";
    };*/
    zen-browser = {
       url = "github:0xc000022070/zen-browser-flake";
       inputs.nixpkgs.follows = "nixpkgs";
       inputs.home-manager.follows = "home-manager";
    };
   };

  outputs = { 
    nixpkgs,
    home-manager,
    #hyprland,
    #pyprland,
    stylix,
    #quickshell,
    #durdraw,
    #hyprsettings,
    zen-browser,
    ... 
    }@inputs:
    let
      system = "x86_64-linux";
      host = "moguch";
      username = "moguch";
    in
    {
      nixosConfigurations = {
        "${host}" = nixpkgs.lib.nixosSystem {
          specialArgs = {
	          inherit system;
            inherit inputs;
            inherit username;
            inherit host;
          };
          modules = [
            ./hosts/${host}/config.nix
            {
            environment.systemPackages = [ 
                #pyprland.packages."${system}".pyprland
                #quickshell.packages."${system}".default
                #durdraw.packages.${system}.default
                #inputs.zen-browser.packages.${system}.default
               
               ];
            }  
            inputs.stylix.nixosModules.stylix
            home-manager.nixosModules.home-manager
            #hyprsettings.nixosModules.default
            {
              #programs.hyprsettings.enable = true;
              home-manager.extraSpecialArgs = {
                inherit username;
                inherit inputs;
                inherit host;
              };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup";
              home-manager.users.${username} = import ./hosts/${host}/home.nix;
            }
            
          ];
        };
      };
    };
}
