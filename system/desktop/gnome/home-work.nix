{ config, lib, ... }:

lib.mkIf config.work.user.enable {
	home-manager.users.${config.work.user.username} = lib.mkIf config.desktop-environment.gnome.enable {

		dconf.settings = {
			"org/gnome/desktop/interface" = {
				# Enable dark mode
				color-scheme = "prefer-dark";
				# Enable clock seconds
				clock-show-seconds = true;
				# Disable date
				clock-show-date = config.desktop-environment.gnome.configuration.clock-date.enable;
			};

			# Disable lockscreen notifications
			"org/gnome/desktop/notifications" = {
				show-in-lock-screen = false;
			};

			"org/gnome/desktop/wm/preferences" = {
				# Disable application is ready notification
				focus-new-windows = "strict";
				# Set number of workspaces
				num-workspaces = 1;
			};

			# Disable mouse acceleration
			"org/gnome/desktop/peripherals/mouse" = {
				accel-profile = "flat";
			};

			# Disable file history
			"org/gnome/desktop/privacy" = {
				remember-recent-files = false;
			};

			# Turn off screen
			"org/gnome/desktop/session" = {
				idle-delay = 270;
			};

			# Disable screen lock
			"org/gnome/desktop/screensaver" = {
				lock-enabled = true;
				lock-delay = 30;
			};

			# Disable system sounds
			"org/gnome/desktop/sound" = {
				event-sounds = false;
			};

			"org/gnome/mutter" = {
				# Enable fractional scaling
				experimental-features = [ "scale-monitor-framebuffer" ];
				# Disable dynamic workspaces
				dynamic-workspaces = false;
			};

			"org/gnome/settings-daemon/plugins/power" = {
				# Disable auto suspend
				sleep-inactive-ac-type = "nothing";
				# Power button shutdown
				power-button-action = "interactive";
			};

			"org/gnome/shell" = {
				# Enable gnome extensions
				disable-user-extensions = false;
				# Set enabled gnome extensions
				enabled-extensions =
				[
					"appindicatorsupport@rgcjonas.gmail.com"
					"arcmenu@arcmenu.com"
					"bluetooth-quick-connect@bjarosze.gmail.com"
					"caffeine@patapon.info"
					"clipboard-indicator@tudmotu.com"
					"color-picker@tuberry"
					"dash-to-panel@jderose9.github.com"
					"emoji-selector@maestroschan.fr"
					"gsconnect@andyholmes.github.io"
					"quick-settings-tweaks@qwreey"
				];
			};

			"org/gnome/shell/keybindings" = {
				# Disable clock shortcut
				toggle-message-tray = [];
			};

			"org/gnome/settings-daemon/plugins/media-keys" = {
				custom-keybindings = [
					"/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
					"/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
				];
			};

			"org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
				binding = "<Super>x";
				command = "kitty";
				name =  "Kitty";
			};

			"org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
				binding = "<Super>e";
				command = "nautilus .";
				name =  "Nautilus";
			};

			# Limit app switcher to current workspace
			"org/gnome/shell/app-switcher" = {
				current-workspace-only = true;
			};

			"org/gnome/shell/extensions/caffeine" = lib.mkIf config.desktop-environment.gnome.configuration.caffeine.enable {
				# Remember the user choice
				restore-state = true;
				# Disable icon
				show-indicator = false;
				# Disable auto suspend and lock
				user-enabled = true;
				# Disable notifications
				show-notifications = false;
			};

			"org/gnome/shell/extensions/clipboard-indicator" = {
				# Remove whitespace before and after the text
				strip-text = true;
				# Open the extension with Super + V
				toggle-menu = [ "<Super>v" ];
			};

			# Disable color picker notifications
			"org/gnome/shell/extensions/color-picker" = {
				enable-notify = false;
			};

			# Do not always show emoji selector
			"org/gnome/shell/extensions/emoji-selector" = {
				always-show = false;
			};
		};
	};
}