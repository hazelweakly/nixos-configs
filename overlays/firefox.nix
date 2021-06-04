final: prev:
let
  n =
    final.inputs.flake-firefox-nightly.packages.x86_64-linux.firefox-nightly-bin.name;

  policies = {
    DisableAppUpdate = true;
    SecurityDevices = {
      p11-kit = "${final.p11-kit}/lib/pkcs11/p11-kit-trust.so";
    };
  };
in
rec {
  firefox-nightly-bin =
    prev.wrapFirefox (firefox-nightly-bin-unwrapped) {
      browserName = "firefox";
      pname = "firefox-bin";
      desktopName = "Firefox";
      firefoxLibName = "${n}";
      extraPolicies = policies;
      extraPrefs = ''
        defaultPref("accessibility.typeaheadfind.enablesound", false);
        defaultPref("accessibility.typeaheadfind.flashBar", 0);
        defaultPref("browser.aboutConfig.showWarning", false);
        defaultPref("browser.ctrlTab.recentlyUsedOrder", false);
        defaultPref("browser.in-content.dark-mode", true);
        defaultPref("browser.proton.enabled", true);
        defaultPref("browser.startup.homepage","about:blank");
        defaultPref("browser.urlbar.keepPanelOpenDuringImeComposition", true);
        defaultPref("gfx.webrender.all", true);
        defaultPref("gfx.webrender.enabled", true);
        defaultPref("gfx.webrender.software", false);
        defaultPref("javascript.options.warp", true);

        defaultPref("layers.gpu-process.enabled", true);
        defaultPref("dom.webgpu.enabled", true);

        defaultPref("layout.css.devPixelsPerPx", "1.4");
        defaultPref("media.ffmpeg.vaapi.enabled", true);
        defaultPref("media.ffvpx.enabled", false);
        defaultPref("network.dns.disablePrefetch", false);
        defaultPref("network.dns.disablePrefetchFromHTTPS", false);
        defaultPref("network.http.http3.enable_qlog", true);
        defaultPref("network.http.speculative-parallel-limit", 20);
        defaultPref("network.predictor.enable", true);
        defaultPref("network.prefetch-next", true);
        defaultPref("pdfjs.enabledCache.state", true);
        defaultPref("pdfjs.enableWebGL", true);
      '';
    };
  firefox-nightly-bin-unwrapped =
    let
      policiesJSON = prev.writeText "policy.json"
        (builtins.toJSON { inherit policies; });
    in
    final.inputs.flake-firefox-nightly.packages.x86_64-linux.firefox-nightly-bin.unwrapped.overrideAttrs
      (
        o: {
          installPhase = (o.installPhase or "") + ''
            ln -sf ${final.p11-kit}/lib/pkcs11/p11-kit-trust.so $out/lib/${n}/libnssckbi.so
            ln -sf ${policiesJSON} $out/lib/${n}/distribution/policies.json
          '';
        }
      );
}
