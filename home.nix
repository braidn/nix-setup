{ config, pkgs, lib, ... }:
let
	pkgsUnstable = import <nixpkgs-unstable> {};
in
{
# Home Manager needs a bit of information about you and the
# paths it should manage.
	home.username = "braidn";
	home.homeDirectory = "/Users/braidn";
	home.packages = [
		pkgs.awscli
		pkgs.git
		pkgs.fd
		pkgs.openssl
		pkgs.ripgrep
		pkgs.nnn
		pkgs.broot
		pkgs.imagemagick
		pkgs.readline
		pkgs.curlie
		pkgs.pinentry
		pkgs.wget
		pkgs.libyaml
		pkgs.dfu-util
		pkgs.dfu-programmer
		pkgs.tree-sitter
		pkgs.zoxide
		pkgs.delta
		pkgs.gnupg
		pkgs.pinentry_mac
		pkgs.julia-mono
		pkgs.nodejs-19_x
		pkgs.ruby_3_1
		(pkgs.nerdfonts.override { fonts = [ "Hasklig" "Iosevka" ]; })
		pkgs.yq
		pkgs.shellcheck
		pkgs.pgcli
		pkgsUnstable.marksman
		pkgsUnstable.deno
	];
	
	fonts.fontconfig.enable = true;

	programs.starship = {
    enable = true;
		enableFishIntegration = true;
		settings = {
			shell = {
				disabled = false;
			};
		};
  };

	programs.kitty = {
		enable = true;
		settings = {
			font_family = "JuliaMono";
			font_size = "13.0";
			disable_ligatures = "cursor";
			hide_window_decoration = "titlebar-only";
			window_padding_width = "10";
			tab_bar_edge = "top";
			tab_bar_style = "powerline";
			tab_tilte_template = "{index -1}: {title.split('/')[-1]}";
		  active_tab_font_style = "bold";
			inactive_tab_font_style = "normal";
			copy_on_select = "yes";
			enable_audo_bell = "no";
		};
		extraConfig = ''
		  symbol_map U+F101-U+F208 nonicons
			symbol_map "U+E5FA-U+E62B,U+E700-U+E7C5,U+F000-U+F2E0,U+E200-U+E2A9,U+F500-U+FD46,U+E300-U+E3EB,U+F400-U+F4A8,U+2665,U+26a1,U+F27C,U+E0A3,U+E0B4-U+E0C8,U+E0CA,U+E0CC-U+E0D2,U+E0D4,U+23FB-U+23FE,U+2B58,U+F300-U+F313,U+E000-U+E00D Hasklug Nerd Font Mono
			
			# The basic colors
			foreground              #CAD3F5
			background              #24273A
			selection_foreground    #24273A
			selection_background    #F4DBD6

			# Cursor colors
			cursor                  #F4DBD6
			cursor_text_color       #24273A

			# URL underline color when hovering with mouse
			url_color               #F4DBD6

			# Kitty window border colors
			active_border_color     #B7BDF8
			inactive_border_color   #6E738D
			bell_border_color       #EED49F

			# OS Window titlebar colors
			wayland_titlebar_color system
			macos_titlebar_color system

			# Tab bar colors
			active_tab_foreground   #181926
			active_tab_background   #C6A0F6
			inactive_tab_foreground #CAD3F5
			inactive_tab_background #1E2030
			tab_bar_background      #181926

			# Colors for marks (marked text in the terminal)
			mark1_foreground #24273A
			mark1_background #B7BDF8
			mark2_foreground #24273A
			mark2_background #C6A0F6
			mark3_foreground #24273A
			mark3_background #7DC4E4

			# The 16 terminal colors

			# black
			color0 #494D64
			color8 #5B6078

			# red
			color1 #ED8796
			color9 #ED8796

			# green
			color2  #A6DA95
			color10 #A6DA95

			# yellow
			color3  #EED49F
			color11 #EED49F

			# blue
			color4  #8AADF4
			color12 #8AADF4

			# magenta
			color5  #F5BDE6
			color13 #F5BDE6

			# cyan
			color6  #8BD5CA
			color14 #8BD5CA

			# white
			color7  #B8C0E0
			color15 #A5ADCB
		'';
  };
	
	programs.helix = {
		enable = true;
		settings = {
			theme = "catppuccin_frappe";
			editor = {
			  true-color = true;
				line-number = "relative";
				mouse = false;
				rulers = [ 80 100 ];
				lsp = {
					display-messages = true;
				};
			};
			editor.cursor-shape = {
				insert = "bar";
				normal = "block";
				select = "underline";
			};
		};
	};

	# nixpkgs.overlays = [
	#   (import (builtins.fetchTarball {
	#     url = https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz;
	# 	}))
	# ];
	
	programs.neovim = {
	  enable = true;
	  # package = pkgs.neovim-nightly;
		# package = pkgsUnstable.neovim;
    viAlias = true;
    withNodeJs = true;
    withPython3 = true;
    withRuby = true;
		extraConfig = "lua require('init')";
		extraPackages = with pkgs; [
			tree-sitter
			nodePackages.typescript nodePackages.typescript-language-server nodePackages.vscode-langservers-extracted nodePackages.yaml-language-server
			rubyPackages.syntax_tree
		];
		plugins = with pkgs.vimPlugins; [
			nvim-lspconfig
			lspkind-nvim
			diaglist-nvim
			cmp-nvim-lsp
			cmp-buffer
			cmp-path
			cmp-cmdline
			nvim-cmp
			cmp-treesitter
			luasnip
			cmp_luasnip
			friendly-snippets
		  telescope-nvim		
			plenary-nvim
			nvim-autopairs
			nvim-comment
			nvim-treesitter
			diffview-nvim
			asynctasks-vim
			asyncrun-vim
			telescope-asynctasks-nvim
			vim-test
			indent-blankline-nvim
			gitsigns-nvim
			git-messenger-vim
			vim-sandwich
			nvim-nonicons
			catppuccin-nvim
			harpoon
			nvim-neoclip-lua
			nvim-web-devicons
			leap-nvim
			null-ls-nvim
			lualine-nvim
			nvim-lsp-ts-utils
		];
	};
	
  home.file.".config/nvim/lua".source = ./nvim/lua;

  programs.zsh = {
		enable = true;
		autocd = true;
		enableAutosuggestions = true;
		enableCompletion = true;
		enableSyntaxHighlighting = true;
		shellAliases = {
		  g = "git";
			f = "fish";
			be = "bundle exec";
			bu = "bundle update";
			bi = "bundle install";
			yarnit = "yarn build";
			nv = "nvim";
			cwd = "pwd | pbcopy";
			ll = "ls -lahG";
			lp = "ls -p";
			lm = "ls -la | more";
			jg = "jobs";
			batl = "bat --paging=never -l log";
			bnix = "nix-shell -p bundler bundix";
		};
		
		initExtra = ''
			# Nix
			if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
				path+=('/nix/var/nix/profiles/default/bin')			  
				. '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
			fi
			# End Nix

		  export AWS_SDK_LOAD_CONFIG='true'
			export VISUAL='hx'
			export EDITOR='hx'
			export GIT_EDITOR='hx'
			export LC_CTYPE=en_US.UTF-8
			export LC_ALL=en_US.UTF-8
			export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow -g "!{.git,node_modules,/ops/node_modules}/*"'
			export FZF_DEFAULT_OPTS='--bind J:down,K:up --ansi '
			export NNN_OPENER='hx'
			export GPG_TTY=$(tty)
			
			path+=('/Users/braidn/.rd/bin')
			eval "$(zoxide init zsh)"
			
			if [[ $TERM_PROGRAM != "WarpTerminal" ]]; then
				eval "$(starship init zsh)"
			fi
			if [ -e '/Users/braidn/.config/op/plugins.sh' ]; then
				source /Users/braidn/.config/op/plugins.sh
			fi
		'';
	};
	
	programs.fzf = {
		enable = true;
		enableZshIntegration = true;
		enableFishIntegration = true;
	};
	
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.gh = {
    enable = true;
		settings  = {
			editor = "nvim";
	    git_protocol = "ssh";	
		};
  };

  programs.jq = {
    enable = true;
  };
	
	programs.bat = {
	  enable = true;
  };


	programs.fish = {
		enable = true;
		plugins = [
			{
				name = "fzf-fish";
				src = pkgs.fetchFromGitHub {
					owner = "PatrickF1";
					repo = "fzf.fish";
					rev = "v9.5";
          sha256 = "ZdHfIZNCtY36IppnufEIyHr+eqlvsIUOs0kY5I9Df6A=";
				};
			}

			{
				name = "bass";
				src = pkgs.fetchFromGitHub {
					owner = "edc";
					repo = "bass";
					rev = "2fd3d2157d5271ca3575b13daec975ca4c10577a";
					sha256 = "fl4/Pgtkojk5AE52wpGDnuLajQxHoVqyphE90IIPYFU=";
				};
			}
			{
				name = "catppuccin";
				src = pkgs.fetchFromGitHub {
					owner = "catppuccin";
					repo = "fish";
					rev = "b90966686068b5ebc9f80e5b90fdf8c02ee7a0ba";
					sha256 = "wQlYQyqklU/79K2OXRZXg5LvuIugK7vhHgpahpLFaOw=";
				};
			}
			{
				name = "fzf-nix";
				src = pkgs.fetchFromGitHub {
					owner = "kidonng";
					repo = "nix.fish";
					rev = "19cfe6c7f1e8ae60865b22197fc43506d78888f8";
					sha256 = "gVHF7qJrqoiUJm0EirP5uAG37P0rbsFIIlc1TtSKsWE=";
				};
			}
		];
		shellAliases = {
			g = "git";
			v = "nvim";
			nv = "nvim";
			cwd = "pwd | pbcopy";
			le = "nnn -de";
			batl = "bat --paging=never -l log";
			be = "bundle exec";
		};
		shellInit = ''
		  set -U fish_term24bit 1
			set -U fish_greeting ""
			gpgconf --launch gpg-agent
		'';
		interactiveShellInit = ''
		  set -e SSH_AUTH_SOCK
			set -Ux SSH_AUTH_SOCK ~/.gnupg/S.gpg-agent.ssh
			set -Ux GPG_TTY (tty)
			set -Ux VISUAL "nvim -f"
			set -Ux EDITOR "nvim -f"
			set -Ux GIT_EDITOR "nvim -f"
			set -Ux AWS_SDK_LOAD_CONFIG true
			set -Ux LC_CTYPE "en_US.UTF-8"
			set -Ux LC_ALL "en_US.UTF-8"
			set -Ux CLICOLOR 1
			set -Ux NNN_OPENER "nvim -f"
			set -Ux AWS_PROFILE mine
			set -Ux KITTY_LISTEN_ON "unix:/tmp/mykitty"
			set -U fish_user_paths ~/.rd/bin $fish_user_paths
			
			set fzf_fd_opts --hidden --exclude=.git
			zoxide init fish | source
			
			# name: 'Catppuccin frappe'
			set fish_color_normal c6d0f5
			set fish_color_command 8caaee
			set fish_color_param eebebe
			set fish_color_keyword e78284
			set fish_color_quote a6d189
			set fish_color_redirection f4b8e4
			set fish_color_end ef9f76
			set fish_color_comment 838ba7
			set fish_color_error e78284
			set fish_color_gray 737994
			set fish_color_selection --background=414559
			set fish_color_search_match --background=414559
			set fish_color_operator f4b8e4
			set fish_color_escape ea999c
			set fish_color_autosuggestion 737994
			set fish_color_cancel e78284
			set fish_color_cwd e5c890
			set fish_color_user 81c8be
			set fish_color_host 8caaee
			set fish_color_host_remote a6d189
			set fish_color_status e78284
			set fish_pager_color_progress 737994
			set fish_pager_color_prefix f4b8e4
			set fish_pager_color_completion c6d0f5
			set fish_pager_color_description 737994
		'';
	};

	home.sessionVariables = {
    EDITOR = "nvim";
    TERMINAL = "kitty";
	};

	programs.git = {
    enable = true;
		lfs.enable = true;
		userName = "Braden Douglass";
		userEmail = "braden.douglass@gmail.com";
		signing = {
			signByDefault = true;
			key = null;
		};
		delta = {
			enable = true;
			options = {
			  plus-style = "syntax #012800";
			  minus-style = "syntax #340001";
			  syntax-theme = "Monokai Extended";
			  navigate = true;
			  line-numbers = true;
				side-by-side = true;
			};
		};
	  includes = [
      { path = "~/.gitconfig_local"; }
    ];
    aliases = {
      ap = "add -p";
			aa = "add --all";
			ai = "add --interactive";
			changes = "diff --name-status -r";
			st = "status -sb";
			ct = "commit";
			cta = "commit --amend";
			br = "branch";
			co = "checkout";
			cot = "checkout -t";
			cob = "checkout -b";
			mg = "merge";
			df = "diff";
			ds = "diff --staged";
			wd = "diff --color-words";
			cd = "diff --name-only --diff-filter=U --relative";
			irb = "rebase --interactive";
			cp = "cherry-pick -s";
			rh = "reset --hard";
			lg = "log -p";
			pl = "pull";
			ph = "push";
			phsu = "push --set-upstream";
			lol = "log --graph --decorate --pretty=oneline --abbrev-commit";
			lola = "log --graph --decorate --pretty=oneline --abbrev-commit --all";
			ls = "ls-files";
			dt = "difftool";
			glg = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'";
			lgl = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
			stall = "stash save --include-untracked";
    };
    extraConfig = {
      pull.ff = "only";
			merge.conflictstyle = "diff3";
			diff.colorMoved = "default";
			github.user = "braidn";
			credential.helper = "osxkeychain";
			init.defaultBranch = "main";
			color.ui = "true";
			core = {
				whitespace = "fix,tab-in-indent,trailing-space,cr-at-eol";
			  editor = "nvim";
			  autocrlf = "input";
			  safecrlf = "warn";
			};
    };
  };
# This value determines the Home Manager release that your
# configuration is compatible with. This helps avoid breakage
# when a new Home Manager release introduces backwards
# incompatible changes.
#
# You can update Home Manager without changing this value. See
# the Home Manager release notes for a list of state version
# changes in each release.
	home.stateVersion = "22.11";

# Let Home Manager install and manage itself.
	programs.home-manager.enable = true;
}
