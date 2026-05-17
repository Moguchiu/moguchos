{ config, pkgs, username, ... }:
{
  services.mpd = {
    enable = true;
    package = pkgs.mpd;
    musicDirectory =  "/home/moguch/Music";
    playlistDirectory = "/home/moguch/Music/playlist";     
     /*extraConfig = ''
      audio_output {
        type    "pipewire"   
        name    "My PipeWire Output"
      }
    '';*/
  };
  programs = {
    #yt-dlp.enable = true;
    rmpc ={
    enable = true;
    };
   };
  }
