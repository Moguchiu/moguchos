{
  pkgs,
  username,
  ...
}:

let
  inherit (import ./variables.nix) gitUsername;
in
{
  users.users = {
    "${username}" = {
      homeMode = "755";
      isNormalUser = true;
      description = "${gitUsername}";
      extraGroups = [
        "audio" 
        "networkmanager"
        "wheel"
        "libvirtd"
        "scanner"
        "lp"
        "input" 
        "disk"
      ];
      #shell = pkgs.bash;
      shell = pkgs.zsh;
      ignoreShellProgramCheck = true;
      #packages = with pkgs; [
      #];
    };
    # "newuser" = {
    #   homeMode = "755";
    #   isNormalUser = true;
    #   description = "New user account";
    #   extraGroups = [ "networkmanager" "wheel" "libvirtd" ];
    #   shell = pkgs.bash;
    #   ignoreShellProgramCheck = true;
    #   packages = with pkgs; [];
    # };
  };
}
