{
  lib,
  testers,
  tuigreet-pkg,
}:
testers.nixosTest {
  name = "tuigreet";
  meta.maintainers = with lib.maintainers; [NotAShelf];

  nodes = {
    machine = {
      users.users.alice = {
        isNormalUser = true;
        description = " Test User";
        password = "test123";
      };

      environment.systemPackages = [tuigreet-pkg];

      services.greetd = {
        enable = true;
        settings = {
          terminal.vt = 1;
          default_session = {
            command = "${tuigreet-pkg}/bin/tuigreet --greeting 'Welcome to tuigreet!' --time --cmd sway";
            user = "greeter";
          };
        };
      };

      # Create a minimal wayland session for testing
      environment.etc."wayland-sessions/sway.desktop".text = ''
        [Desktop Entry]
        Name=Sway
        Comment=An i3-compatible Wayland compositor
        Exec=sway
        Type=Application
      '';

      # Create cache directory for tuigreet remember features
      systemd.tmpfiles.rules = [
        "d /var/cache/tuigreet 0755 greeter greeter -"
      ];
    };
  };

  # FIXME: the tests are very barebones right now, because I have not yet
  # figured out a way to test a TUI greeter. For now let's do some VERY
  # basic "verification", and we'll use this test with the interactive
  # driver for manual testing.
  testScript = ''
    machine.wait_for_unit("greetd.service")
    machine.wait_for_unit("getty@tty1.service")

    # Check that greetd is running
    machine.succeed("pgrep -f greetd")

    # Check that tuigreet is running
    machine.succeed("pgrep -f tuigreet")
  '';
}
