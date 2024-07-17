{
  # Inspiration from https://github.com/skbolton/nix-dotfiles
  description = "Nathan's NixOS configuration";

  inputs = {
    # NixOS official package source
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";

    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
  let
    inherit (self) outputs;
  in {
    nixosConfigurations = {
      nathan-desktop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        # The Nix module system can modularise configuration, improving the maintainability of configuration.

        # Each parameter in the `modules` is a Nix Module, and there is a partial introduction to it in the nixpkgs manual.
        # <https://nixos.org/manual/nixpkgs/unstable/#module-system-introduction>
        # It's partial because docs aren't complete, only some simple intros.
        # A Nix Module can be an attribute set, or a function that returns an attribute set.
        # If a Module is a function, it can only have the following parameters:
        # lib: the nixpkgs function library, which has useful functions for Nix expressions
        #      <https://nixos.org/manua/nixpkgs/stable/#id-1.4>
        # config: all config options of the current flake
        # options: all options defined in all NixOS Modules in the current flake
        # pkgs: a collection of all packages defined in nixpkgs.
        #       assume its default is `nixpkgs.legacyPackages."${system}"` for now.
        #       can be customised by `nixpkgs.pkgs` option
        # modulesPath: the default path of nixpkgs' builtin modules folder, used
        #              to import some extra modules from nixpkgs. rarely used, ignore.
        # Only these parameters can be passed by default.
        # If other params needed, use `nixpkgs.lib.nixosSystem.specialArgs`
        # e.g. specialArgs = { inherit inputs outputs; };
        # Or within a module, you can use `_module.args`
        # e.g. _module.args = { inherit inputs; };
        specialArgs = { inherit inputs outputs; };
        modules = [
          ./hosts/nathan-desktop
          # Make home-manager be a module of nixOS so it will be deployed
          # automatically when running rebuild
          home-manager.nixosModules.home-manager {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = { inherit inputs; };
              users.nathan = import ./home/nathan-desktop;

              # Optionally, use extraSpecialArgs to pass arguments to home.nix
            };
          }
        ];
      };
    };
  };
}
