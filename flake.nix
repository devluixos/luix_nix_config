{
  inputs = {
    # keep nixpkgs aligned with your 25.05 system to avoid option mismatches
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nix-gaming.url = "github:fufexan/nix-gaming";
    # Star Citizen flake
    nix-citizen.url = "github:LovingMelody/nix-citizen";
  };

  outputs = { self, nixpkgs, nix-gaming, nix-citizen, ... }@inputs: {
    # name matches your host ('nixos') so nixos-rebuild finds it automatically
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [ ./configuration.nix ];
    };
  };
}

