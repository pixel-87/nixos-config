{ inputs, config, lib, pkgs, ... }:{ inputs, config, lib, pkgs, ... }:



{{

  programs.zen-browser = {  imports = [ inputs.zen-browser.homeModules.default ];

    enable = true;

    # Any other options under `programs.firefox` are also supported here  programs.zen-browser = {

    profiles.pixel = {    enable = true;

      extensions.packages = with inputs.firefox-addons.packages.${pkgs.system}; [    # Any other options under `programs.firefox` are also supported here

        ublock-origin    profiles.pixel = {

        consent-o-matic      extensions.packages = with inputs.firefox-addons.packages.${pkgs.system}; [

        privacy-badger        ublock-origin

        proton-pass        consent-o-matic

        return-youtube-dislike        privacy-badger

        sponsorblock        proton-pass

      ];        return-youtube-dislike

        sponsorblock

      settings = {      ];

        # Disable telemetry and data collection

        "datareporting.policy.dataSubmissionPolicyAcceptedVersion" = 2;      settings = {

        "datareporting.policy.dataSubmissionPolicyNotifiedTime" = "1";        # Disable telemetry and data collection

        "datareporting.healthreport.uploadEnabled" = false;        "datareporting.policy.dataSubmissionPolicyAcceptedVersion" = 2;

        "toolkit.telemetry.enabled" = false;        "datareporting.policy.dataSubmissionPolicyNotifiedTime" = "1";

        "toolkit.telemetry.archive.enabled" = false;        "datareporting.healthreport.uploadEnabled" = false;

        "toolkit.telemetry.reportingpolicy.firstRun" = false;        "toolkit.telemetry.enabled" = false;

        "toolkit.coverage.opt-out" = true;        "toolkit.telemetry.archive.enabled" = false;

        "toolkit.coverage.endpoint.base" = "";        "toolkit.telemetry.reportingpolicy.firstRun" = false;

        "toolkit.coverage.opt-out" = true;

        # Disable studies and experiments        "toolkit.coverage.endpoint.base" = "";

        "app.shield.optoutstudies.enabled" = false;

        "app.normandy.enabled" = false;        # Disable studies and experiments

        "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";        "app.shield.optoutstudies.enabled" = false;

        "app.normandy.enabled" = false;

        # Disable activity stream (new tab page telemetry)        "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";

        "browser.newtabpage.activity-stream.enabled" = false;

        "browser.newtabpage.activity-stream.telemetry" = false;        # Disable activity stream (new tab page telemetry)

        "browser.newtabpage.preload" = false;        "browser.newtabpage.activity-stream.enabled" = false;

        "browser.newtabpage.activity-stream.telemetry" = false;

        # Disable suggestions and sponsored content        "browser.newtabpage.preload" = false;

        "browser.urlbar.suggest.searches" = false;

        "browser.urlbar.suggest.openpage" = false;        # Disable suggestions and sponsored content

        "browser.urlbar.suggest.history" = false;        "browser.urlbar.suggest.searches" = false;

        "browser.urlbar.suggest.bookmark" = false;        "browser.urlbar.suggest.openpage" = false;

        "browser.urlbar.suggest.topsites" = false;        "browser.urlbar.suggest.history" = false;

        "browser.urlbar.suggest.engines" = false;        "browser.urlbar.suggest.bookmark" = false;

        "browser.search.suggest.enabled" = false;        "browser.urlbar.suggest.topsites" = false;

        "browser.search.suggest.enabled.private" = false;        "browser.urlbar.suggest.engines" = false;

        "browser.search.suggest.enabled" = false;

        # Privacy - Enhanced Tracking Protection        "browser.search.suggest.enabled.private" = false;

        "privacy.trackingprotection.enabled" = true;

        "privacy.trackingprotection.socialtracking.enabled" = true;        # Privacy - Enhanced Tracking Protection

        "privacy.trackingprotection.enabled" = true;

        # Disable pocket        "privacy.trackingprotection.socialtracking.enabled" = true;

        "extensions.pocket.enabled" = false;

        # Disable pocket

        # Disable Firefox view        "extensions.pocket.enabled" = false;

        "browser.tabs.firefox-view.firsttimeexperience.enabled" = false;

        # Disable Firefox view

        # Disable password manager sync        "browser.tabs.firefox-view.firsttimeexperience.enabled" = false;

        "signon.management.page.breach-alerts.enabled" = false;

        # Disable password manager sync

        # DNS over HTTPS        "signon.management.page.breach-alerts.enabled" = false;

        "network.trr.mode" = 2;

        "network.trr.uri" = "https://cloudflare-dns.com/dns-query";        # DNS over HTTPS

        "network.trr.mode" = 2;

        # Cookie settings        "network.trr.uri" = "https://cloudflare-dns.com/dns-query";

        "network.cookie.cookieBehavior" = 4; # Reject trackers only

        "privacy.partition.network_state" = true;        # Cookie settings

        "network.cookie.cookieBehavior" = 4; # Reject trackers only

        # WebRTC IP leak protection        "privacy.partition.network_state" = true;

        "media.peerconnection.enabled" = true;

        "media.peerconnection.ice.default_address_only" = true;        # WebRTC IP leak protection

        "media.peerconnection.enabled" = true;

        # Disable autofill        "media.peerconnection.ice.default_address_only" = true;

        "extensions.formautofill.addresses.enabled" = false;

        "extensions.formautofill.creditCards.enabled" = false;        # Disable autofill

        "extensions.formautofill.addresses.enabled" = false;

        # Disable geolocation        "extensions.formautofill.creditCards.enabled" = false;

        "geo.enabled" = false;

        "geo.provider.use_corelocation" = false;        # Disable geolocation

        "geo.enabled" = false;

        # Disable notifications by default        "geo.provider.use_corelocation" = false;

        "dom.webnotifications.enabled" = false;

        # Disable notifications by default

        # Fingerprinting protection        "dom.webnotifications.enabled" = false;

        "privacy.resistFingerprinting" = false; # Keep false for better compatibility

        "privacy.trackingprotection.fingerprinting.enabled" = true;        # Fingerprinting protection

        "privacy.trackingprotection.cryptomining.enabled" = true;        "privacy.resistFingerprinting" = false; # Keep false for better compatibility

        "privacy.trackingprotection.fingerprinting.enabled" = true;

        # Safe browsing (disable if you trust your antivirus)        "privacy.trackingprotection.cryptomining.enabled" = true;

        "browser.safebrowsing.malware.enabled" = true;

        "browser.safebrowsing.phishing.enabled" = true;        # Safe browsing (disable if you trust your antivirus)

      };        "browser.safebrowsing.malware.enabled" = true;

    };        "browser.safebrowsing.phishing.enabled" = true;

  };      };

}    };
  };
}
