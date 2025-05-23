{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.drivers.nvidia-prime;
in
{
  options.drivers.nvidia-prime = {
    enable = mkEnableOption "Enable Nvidia Prime Hybrid GPU Offload";
    amdgpuBusID = mkOption {
      type = types.str;
      default = "PCI:6:0:0";
    };
    nvidiaBusID = mkOption {
      type = types.str;
      default = "PCI:1:0:0";
    };
  };

  config = mkIf cfg.enable {
    hardware.nvidia = {
      prime = {
        sync.enable = true;
        #offload = {
        #enable = true;
        #enableOffloadCmd = true;
        #};
        # Make sure to use the correct Bus ID values for your system!
        amdgpuBusId = "${cfg.amdgpuBusID}";
        nvidiaBusId = "${cfg.nvidiaBusID}";
      };
    };
  };
}
