{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

let
  firefoxAddons = (import inputs.firefox-addons { inherit pkgs; }).firefox-addons;
in
{
  programs.firefox = {
    enable = true;
    profiles.pixel = {
      extensions.packages = with firefoxAddons; [
        ublock-origin
        consent-o-matic
        privacy-badger
      ];

      settings = {
        # Disable telemetry and data collection
        "datareporting.policy.dataSubmissionPolicyAcceptedVersion" = 2;
        "datareporting.policy.dataSubmissionPolicyNotifiedTime" = "1";
        "datareporting.healthreport.uploadEnabled" = false;
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.archive.enabled" = false;
        "toolkit.telemetry.reportingpolicy.firstRun" = false;
        "toolkit.coverage.opt-out" = true;
        "toolkit.coverage.endpoint.base" = "";

        # Disable studies and experiments
        "app.shield.optoutstudies.enabled" = false;
        "app.normandy.enabled" = false;
        "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";

        # Disable activity stream (new tab page telemetry)
        "browser.newtabpage.activity-stream.enabled" = false;
        "browser.newtabpage.activity-stream.telemetry" = false;
        "browser.newtabpage.preload" = false;

        # Disable suggestions and sponsored content
        "browser.urlbar.suggest.searches" = false;
        "browser.urlbar.suggest.openpage" = false;
        "browser.urlbar.suggest.history" = false;
        "browser.urlbar.suggest.bookmark" = false;
        "browser.urlbar.suggest.topsites" = false;
        "browser.urlbar.suggest.engines" = false;
        "browser.search.suggest.enabled" = false;
        "browser.search.suggest.enabled.private" = false;

        # Privacy - Enhanced Tracking Protection
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;

        # Disable pocket
        "extensions.pocket.enabled" = false;

        # Disable Firefox view
        "browser.tabs.firefox-view.firsttimeexperience.enabled" = false;

        # Disable password manager sync
        "signon.management.page.breach-alerts.enabled" = false;

        # DNS over HTTPS
        "network.trr.mode" = 2;
        "network.trr.uri" = "https://cloudflare-dns.com/dns-query";

        # Cookie settings
        "network.cookie.cookieBehavior" = 4; # Reject trackers only
        "privacy.partition.network_state" = true;

        # WebRTC IP leak protection
        "media.peerconnection.enabled" = true;
        "media.peerconnection.ice.default_address_only" = true;

        # Disable autofill
        "extensions.formautofill.addresses.enabled" = false;
        "extensions.formautofill.creditCards.enabled" = false;

        # Disable geolocation
        "geo.enabled" = false;
        "geo.provider.use_corelocation" = false;

        # Disable notifications by default
        "dom.webnotifications.enabled" = false;

        # Fingerprinting protection
        "privacy.resistFingerprinting" = false; # Keep false for better compatibility
        "privacy.trackingprotection.fingerprinting.enabled" = true;
        "privacy.trackingprotection.cryptomining.enabled" = true;

        # Safe browsing (disable if you trust your antivirus)
        "browser.safebrowsing.malware.enabled" = true;
        "browser.safebrowsing.phishing.enabled" = true;
      };
    };
  };
}
