/**
  # trippy

  trippy (`trip`) combines the functionality of `traceroute` and `ping`
  and is designed to assist with the analysis of networking issues.

  ## 🛠️ Tech Stack

  - [Trippy homepage](https://trippy.rs/)
    ([Trippy @ GitHub](https://github.com/fujiapple852/trippy)).

  ## 📝 Documentation

  ### 🏠 Home Manager

  - [programs.trippy @ Home Manager](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.trippy.enable).
  - [programs.trippy @ NixOS reference](https://search.nixos.org/options?source=home_manager&query=programs.trippy.).
*/
{
  config,
  lib,
  ...
}:
let
  inherit (lib.modules) mkDefault mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.biapy.programs.trippy;

in
{
  options = {
    biapy.programs.trippy.enable = mkEnableOption "trippy";
  };

  config = mkIf cfg.enable {
    programs.trippy = {
      enable = mkDefault true;

      settings = {
        "trippy" = {
          # The Trippy mode.
          #
          # Allowed values are:
          #   tui         - Display interactive Tui [default]
          #   stream      - Display a continuous stream of tracing data
          #   pretty      - Generate a pretty text table report for N cycles
          #   markdown    - Generate a Markdown text table report for N cycles
          #   csv         - Generate a CSV report for N cycles
          #   json        - Generate a JSON report for N cycles
          #   dot         - Generate a Graphviz DOT report for N cycles
          #   flows       - Display all flows for N cycles
          #   silent      - Do not generate any output for N cycles
          #
          # Note: the dot and flows modes are only allowed with paris or dublin
          # multipath strategy.
          "mode" = mkDefault "tui";

          # Trace without requiring elevated privileges [default: false]
          #
          # Enabling will cause IPPROTO_ICMP sockets to be used.
          #
          # Note: not supported on all platforms.
          "unprivileged" = mkDefault false;

        };

        #
        # Tracing strategy configuration.
        #
        "strategy" = {

          # The address family.
          #
          # Allowed values are:
          #   ipv4            - Lookup IPv4 only
          #   ipv6            - Lookup IPv6 only
          #   ipv6-then-ipv4  - Lookup IPv6 with a fallback to IPv4
          #   ipv4-then-ipv6  - Lookup IPv4 with a fallback to IPv6 [default]
          #   system          - If the OS resolver is being used then use the first IP address returned,
          #                     otherwise lookup IPv6 with a fallback to IPv4.
          "addr-family" = mkDefault "ipv4-then-ipv6";

          # The tracing protocol.
          #
          # Allowed values are:
          #   icmp [default]
          #   udp
          #   tcp
          "protocol" = mkDefault "icmp";
        };

        # Tui key bindings Configuration.
        #
        # The supported modifiers are: shift, ctrl, alt, super, hyper & meta. Multiple
        # modifiers may be specified, for example ctrl+shift+b.
        #
        # See https://github.com/fujiapple852/trippy#key-bindings-reference for details.
        "bindings" = {
          "address-mode-both" = mkDefault "b";
          "address-mode-host" = mkDefault "n";
          "address-mode-ip" = mkDefault "i";
          "chart-zoom-in" = mkDefault "=";
          "chart-zoom-out" = mkDefault "-";
          "clear-dns-cache" = mkDefault "ctrl+k";
          "clear-selection" = mkDefault "esc";
          "clear-trace-data" = mkDefault "ctrl+r";
          "contract-hosts" = mkDefault "[";
          "contract-hosts-min" = mkDefault "{";
          "contract-privacy" = mkDefault "o";
          "expand-hosts" = mkDefault "]";
          "expand-hosts-max" = mkDefault "}";
          "expand-privacy" = mkDefault "p";
          "next-hop" = mkDefault "down";
          "next-hop-address" = mkDefault ".";
          "next-trace" = mkDefault "right";
          "previous-hop" = mkDefault "up";
          "previous-hop-address" = mkDefault ",";
          "previous-trace" = mkDefault "left";
          "quit" = mkDefault "q";
          "quit-preserve-screen" = mkDefault "shift+q";
          "toggle-as-info" = mkDefault "z";
          "toggle-chart" = mkDefault "c";
          "toggle-flows" = mkDefault "f";
          "toggle-freeze" = mkDefault "ctrl+f";
          "toggle-help" = mkDefault "h";
          "toggle-help-alt" = mkDefault "?";
          "toggle-hop-details" = mkDefault "d";
          "toggle-map" = mkDefault "m";
          "toggle-settings" = mkDefault "s";
          "toggle-settings-bindings" = mkDefault "5";
          "toggle-settings-columns" = mkDefault "7";
          "toggle-settings-dns" = mkDefault "3";
          "toggle-settings-geoip" = mkDefault "4";
          "toggle-settings-theme" = mkDefault "6";
          "toggle-settings-trace" = mkDefault "2";
          "toggle-settings-tui" = mkDefault "1";
        };
        "dns" = {
          # How DNS queries are resolved
          #
          # Allowed values are:
          #   system      - Resolve using the OS resolver [default]
          #   resolv      - Resolve using the `/etc/resolv.conf` DNS configuration
          #   google      - Resolve using the Google `8.8.8.8` DNS service
          #   cloudflare  - Resolve using the Cloudflare `1.1.1.1` DNS service
          "dns-resolve-method" = mkDefault "system";

          # Whether to lookup AS information [default: false]
          #
          # If enabled, AS (autonomous system) information is retrieved during DNS
          # queries.
          "dns-lookup-as-info" = false;

          # Trace to all IPs resolved from DNS lookup (ICMP only) [default: false]
          #
          # When set to true a trace will be started for all IPs resolved for all given targets.
          # When set to false a trace will be started for one arbitrarily chosen IP per given target.
          "dns-resolve-all" = false;

          "dns-timeout" = mkDefault "5s";
          "dns-ttl" = mkDefault "300s";
        };
        "report" = {
          # The number of report cycles to run [default: 10]
          #
          # Only applicable for modes pretty, markdown, csv and json.
          "report-cycles" = 10;
        };
        "tui" = {
          # How to render addresses.
          #
          # Allowed values are:
          #   ip - Show IP address only
          #   host - Show reverse-lookup DNS hostname only [default]
          #   both - Show both IP address and reverse-lookup DNS hostname
          "tui-address-mode" = mkDefault "host";

          # How to render autonomous system (AS) information.
          #
          # Allowed values are:
          #   asn             - Show the ASN [default]
          #   prefix          - Display the AS prefix
          #   country-code    - Display the country code
          #   registry        - Display the registry name
          #   allocated       - Display the allocated date
          #   name            - Display the AS name
          "tui-as-mode" = mkDefault "asn";

          # Custom columns to be displayed in the TUI hops table.
          #
          # Default values:
          #
          #   h - Ttl
          #   o - Hostname
          #   l - Loss %
          #   s - Probes sent
          #   r - Responses received
          #   a - Last RTT
          #   v - Average RTT
          #   b - Best RTT
          #   w - Worst RTT
          #   d - Stddev
          #   t - Status
          #
          # Also available:
          #
          #   j - Jitter
          #   g - Jitter average
          #   x - Jitter max
          #   i - Jitter intra
          #   Q - Last probe sequence number
          #   S - Last probe source port
          #   P - Last probe destination port
          #   T - Last icmp packet type
          #   C - Last icmp packet code
          #   N - Last NAT status
          #   f - Probes failed
          #   F = Forward loss
          #   B = Backward loss
          #   D = Forward loss %
          #   K = Differentiated Services Code Point (DSCP) of the Original Datagram
          #   M = Explicit Congestion Notification (ECN) of the Original Datagram
          #
          # The columns will be shown in the order specified.
          "tui-custom-columns" = mkDefault "holsravbwdt";

          # How to render GeoIp information.
          #
          # Allowed values are:
          #   off - Do not show GeoIp information [default]
          #   short - Show short format GeoIp information
          #   long - Show long format GeoIp information
          #   location - Show latitude and Longitude format GeoIp information
          #
          # Note this value is ignored unless a valid geoip-mmdb-file value is also provided.
          "tui-geoip-mode" = mkDefault "off";

          # Supported mmdb formats:
          #   MaxMind "GeoLite2 City"
          #   IPinfo "IP to Country + ASN Database"
          #   IPinfo "IP to Geolocation Extended Database"
          # geoip-mmdb-file = "/path/to/geoip_file.mmdb"

          # How to render ICMP extensions.
          #
          #   off             - Do not show icmp extensions [default]
          #   mpls            - Show MPLS label(s) only
          #   full            - Show full icmp extension data for all known extensions
          #   all             - Show full icmp extension data for all classes
          "tui-icmp-extension-mode" = mkDefault "off";

          # The maximum number of addresses to show per hop [default: auto]
          #
          # Use a zero value for `auto`.
          "tui-max-addrs" = mkDefault 0;

          # Whether to preserve the screen on exit [default: false]
          "tui-preserve-screen" = mkDefault false;

          # The Tui refresh rate [default: 100ms]
          "tui-refresh-rate" = mkDefault "100ms";
        };
      };
    };
  };
}
