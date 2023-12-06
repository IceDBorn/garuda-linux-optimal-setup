{ config, pkgs, lib, ... }:

lib.mkIf config.system.user.main.enable {
  home-manager.users.${config.system.user.main.username} = {
    gtk = {
      enable = true;
      theme.name = "Adwaita-dark";
      cursorTheme.name = "Bibata-Modern-Classic";
      iconTheme.name = "Tela-black-dark";
    }; # Change GTK themes

    dconf.settings = {
      "org/gnome/nautilus/preferences" = {
        always-use-location-entry = true;
      }; # Nautilus path bar is always editable

      "org/gtk/gtk4/settings/file-chooser" = {
        sort-directories-first = true;
      }; # Nautilus sorts directories first

      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      }; # Enable dark mode
    };

    xdg = {
      # Force creation of mimeapps
      configFile."mimeapps.list".force = true;

      desktopEntries = {
        # Codium profile used a an IDE
        codiumIDE = {
          exec =
            "codium --user-data-dir /home/${config.system.user.main.username}/.config/VSCodiumIDE";
          icon = "codium";
          name = "Codium IDE";
          terminal = false;
          type = "Application";
        };

        # Firefox PWA
        pwas = {
          exec =
            "firefox --no-remote -P PWAs --name pwas ${config.applications.firefox.pwas.sites}";
          icon = "firefox-nightly";
          name = "Firefox PWAs";
          terminal = false;
          type = "Application";
        };

        # Run signal without a tray icon
        signal = {
          exec = "signal-desktop --hide-tray-icon";
          icon = "signal-desktop";
          name = "Signal - No tray";
          terminal = false;
          type = "Application";
        };
      };

      # Default apps
      mimeApps = {
        enable = true;

        defaultApplications = {
          "application/pdf" = "firefox.desktop";
          "application/x-bittorrent" = "de.haeckerfelix.Fragments.desktop";
          "application/x-ms-dos-executable" = "wine.desktop";
          "application/x-shellscript" = "codium.desktop";
          "application/x-wine-extension-ini" = "codium.desktop";
          "application/zip" = "org.gnome.FileRoller.desktop";
          "image/avif" = "org.gnome.gThumb.desktop";
          "image/jpeg" = "org.gnome.gThumb.desktop";
          "image/png" = "org.gnome.gThumb.desktop";
          "image/svg+xml" = "org.gnome.gThumb.desktop";
          "text/html" = "firefox.desktop";
          "text/plain" = "codium.desktop";
          "video/mp4" = "mpv.desktop";
          "x-scheme-handler/http" = "firefox.desktop";
          "x-scheme-handler/https" = "firefox.desktop";
          "x-scheme-handler/about" = "firefox.desktop";
          "x-scheme-handler/unknown" = "firefox.desktop";
        };
      };
    };

    home.file = {
      # New document options for nautilus
      "Templates/new".text = "";

      "Templates/new.cfg".text = "";

      "Templates/new.ini".text = "";

      "Templates/new.sh".text = "";

      "Templates/new.txt".text = "";

      ".icons/default" = {
        source = "${pkgs.bibata-cursors}/share/icons/Bibata-Modern-Classic";
        recursive = true;
      }; # Set icon theme fot QT apps and Hyprland
    };
  };
}
