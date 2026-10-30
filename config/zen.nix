{ inputs,
  pkgs,
  lib,
  host,
  config,
  ... }:
{
   imports = [
    #inputs.zen-browser.homeModules.beta
    inputs.zen-browser.homeModules.twilight
    #inputs.zen-browser.homeModules.twilight-official
  ];

 programs.zen-browser = {
   enable = true;
   setAsDefaultBrowser = true;
   nativeMessagingHosts = [pkgs.firefoxpwa];
   policies = {
    AutofillAddressEnabled = true;
    AutofillCreditCardEnabled = false;
    DisableAppUpdate = true;
    DisableFeedbackCommands = true;
    DisableFirefoxStudies = true;
    DisablePocket = true;
    DisableTelemetry = true;
    DontCheckDefaultBrowser = true;
    NoDefaultBookmarks = true;
    OfferToSaveLogins = true;
    EnableTrackingProtection = {
      Value = true;
      Locked = true;
      Cryptomining = true;
      Fingerprinting = true;
    };
   };
    /*# Здесь же применяются ваши настройки для аппаратного декодирования
    profiles.default.settings = {
      "media.ffmpeg.vaapi.enabled" = true;
      "media.hardware-video-decoding.force-enabled" = true;
    };*/ 
 
  };


}
