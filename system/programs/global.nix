### PACKAGES INSTALLED ON ALL USERS ###
{ pkgs, config, ... }:

{
	boot.kernelPackages = pkgs.linuxPackages_zen; # Use ZEN linux kernel

	environment.systemPackages = with pkgs; [
		(callPackage ./self-built/system-monitoring-center.nix { buildPythonApplication = pkgs.python3Packages.buildPythonApplication; fetchPypi = pkgs.python3Packages.fetchPypi; pygobject3 = pkgs.python3Packages.pygobject3; }) # Task manager
		(callPackage ./self-built/webcord { electron = pkgs.electron_21; }) # An open source discord client
		(callPackage ./self-built/apx.nix {}) # Package manager using distrobox
		android-tools # Tools for debugging android devices
		appimage-run # Appimage runner
		# aria # Terminal downloader with multiple connections support
		bat # Better cat command
		btop # System monitor
		# direnv # Unclutter your .profile
		discord
		efibootmgr # Edit EFI entries
		firefox # Browser
		gimp # Image editor
		git # Distributed version control system
		gping # ping with a graph
		# helvum # Pipewire patchbay
		killall # Tool to kill all programs matching process name
		kitty # Terminal
		lsd # Better ls command
		mpv # Video player
		mullvad-vpn # VPN Client
		ntfs3g # Support NTFS drives
		obs-studio # Recording/Livestream
		onlyoffice-bin # Microsoft Office alternative for Linux
		p7zip # 7zip
		python3 # Python
		# ranger # Terminal file manager
		rnnoise-plugin # A real-time noise suppression plugin
		signal-desktop # Encrypted messaging platform
		spotify # Music
		sublime4 # Text editor
		# syncthing # Local file sync
		tree # Display folder content at a tree format
		unrar # Support opening rar files
		usbimager # ISO Burner
		vscodium # All purpose IDE
		jetbrains.webstorm # Javascript IDE
		wget # Terminal downloader
		wine # Compatibility layer capable of running Windows applications
		winetricks # Wine prefix settings manager
		woeusb # Windows ISO Burner
		xorg.xhost # Use x.org server with distrobox
		zenstates # Ryzen CPU controller
		# zerotierone # Virtual lan network
	];

	users.defaultUserShell = pkgs.zsh; # Use ZSH shell for all users

	programs = {
		zsh = {
			enable = true;
			# Enable oh my zsh and it's plugins
			ohMyZsh = {
				enable = true;
				plugins = [ "git" "npm" "nvm" "sudo" "systemd" ];
			};
			autosuggestions.enable = true;

			syntaxHighlighting.enable = true;

			# Aliases
			shellAliases = {
				apx="apx --aur"; # Use arch as the base apx container
				aria2c="aria2c -j 16 -s 16"; # Download with aria using best settings
				cat="bat"; # Better cat command
				chmod="sudo chmod"; # It's a command that I always execute with sudo
				clear-keys="sudo rm -rf ~/ local/share/keyrings/* ~/ local/share/kwalletd/*"; # Clear system keys
				cp="rsync -rP"; # Copy command with details
				desktop-files-list="ls -l /run/current-system/sw/share/applications"; # Show desktop files location
				list-packages="nix-store --query --requisites /run/current-system | cut -d- -f2- | sort | uniq"; # List installed nix packages
				ls="lsd"; # Better ls command
				mva="rsync -rP --remove-source-files"; # Move command with details
				ping="gping"; # ping with a graph
				reboot-windows="sudo efibootmgr --bootnext ${config.boot.windows-entry} && reboot"; # Reboot to windows
				rebuild="(cd $(head -1 /etc/nixos/.configuration-location) 2> /dev/null || (echo 'Configuration path is invalid. Run rebuild.sh manually to update the path!' && false) && bash rebuild.sh)"; # Rebuild the system configuration
				restart-pipewire="systemctl --user restart pipewire"; # Restart pipewire
				ssh="TERM=xterm-256color ssh"; # SSH with colors
				steam-link="killall steam 2> /dev/null ; while ps axg | grep -vw grep | grep -w steam > /dev/null; do sleep 1; done && (nohup steam -pipewire > /dev/null &) 2> /dev/null"; # Kill existing steam process and relaunch steam with the pipewire flag
				update="(cd $(head -1 /etc/nixos/.configuration-location) 2> /dev/null || (echo 'Configuration path is invalid. Run rebuild.sh manually to update the path!' && false) && sudo nix flake update && bash rebuild.sh) ; (apx --aur upgrade) ; (bash ~/.config/zsh/proton-ge-updater.sh)"; # Update everything
				vpn-off="mullvad disconnect"; # Disconnect from VPN
				vpn-on="mullvad connect"; # Connect to VPN
				vpn="mullvad status"; # Show VPN status

				twokify="
					xrandr --delmode DisplayPort-0 '2560x1440_144.00' ;
					xrandr --rmmode '2560x1440_144.00' ;
					xrandr --newmode '2560x1440_144.00' 808.75 2560 2792 3072 3584 1440 1443 1448 1568 -hsync +vsync &&
					xrandr --addmode DisplayPort-0 '2560x1440_144.00' &&
					sleep 1 &&
					xrandr --output DisplayPort-0 --mode '2560x1440_144.00'
				";
				fourkify="
					xrandr --delmode DisplayPort-0 '3440x1440_144.00' ;
					xrandr --rmmode '3440x1440_144.00' ;
					xrandr --newmode '3440x1440_144.00' 1086.75 3440 3744 4128 4816 1440 1443 1453 1568 -hsync +vsync &&
					xrandr --addmode DisplayPort-0 '3440x1440_144.00' &&
					sleep 1 &&
					xrandr --output DisplayPort-0 --mode '3440x1440_144.00'
				";
			};

			interactiveShellInit = "source ~/.config/zsh/zsh-theme.zsh\nunsetopt PROMPT_SP"; # Commands to run on zsh shell initialization
		};

		gamemode.enable = true;
	};

	services = {
		openssh.enable = true;
		mullvad-vpn.enable = true;
	};

	# Symlink files and folders to /etc
	environment.etc."rnnoise-plugin/librnnoise_ladspa.so".source = "${pkgs.rnnoise-plugin}/lib/ladspa/librnnoise_ladspa.so";
	environment.etc."proton-ge-nix".source = "${(pkgs.callPackage self-built/proton-ge.nix {})}/";
	environment.etc."apx/config.json".source = "${(pkgs.callPackage self-built/apx.nix {})}/etc/apx/config.json";
}
