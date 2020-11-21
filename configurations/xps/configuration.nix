{ pkgs, ... }:
with builtins;
{
  imports = [
    <nixos-hardware/common/cpu/intel>
    <nixos-hardware/common/pc/laptop>
    <nixos-hardware/common/pc/laptop/ssd>
    ./hardware-configuration.nix
    ../common.nix
  ];

  boot.blacklistedKernelModules = [ "psmouse" ];
  nixpkgs.config.pulseaudio = true;
  hardware = {
    cpu.intel.updateMicrocode = true;
    enableAllFirmware = true;

    pulseaudio = {
      enable = true;
      support32Bit = true;
      extraConfig = "load-module module-switch-on-connect";
    };

    opengl = {
      driSupport32Bit = true;
      extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
    };

    bluetooth.enable = true;
    bluetooth.package = pkgs.bluezFull;
  };
  networking = {
    hostName = "keith-nixos";
    networkmanager.enable = true;
    networkmanager.wifi.powersave = false;
  };
  fonts.enableDefaultFonts = true;
  services.autorandr.enable = true;
  services.xserver.enable = true;

  users.mutableUsers = false;
  users.users.keith.hashedPassword = readFile /etc/nixos/secrets/keith-password;
  users.users.root.hashedPassword = readFile /etc/nixos/secrets/root-password;
}