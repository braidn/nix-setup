 config, pkgs, lib, ... }:
let
	pkgsUnstable = import <nixpkgs-unstable> {};
	fromGitHub = rev: ref: repo: pkgs.vimUtils.buildVimPlugin {
    pname = "${lib.strings.sanitizeDerivationName repo}";
    version = ref;
    src = builtins.fetchGit {
      url = "https://github.com/${repo}.git";
      ref = ref;
      rev = rev;
    };
  };
in
{
# Home Manager needs a bit of information about you and the
# paths it should manage.
	home.username = "braidn";
	home.homeDirectory = "/Users/braidn";
	home.packages = [
		pkgs.awscli2
		pkgs.git
		pkgs.gh
		pkgs.fd
		pkgs.openssl
		pkgs.ripgrep
		pkgs.nnn
		pkgs.broot
		pkgs.imagemagick
		pkgs.readline
		pkgs.curlie
		pkgs.wget
		pkgs.libyaml
		pkgs.dfu-util
		pkgs.dfu-programmer
		pkgs.tree-sitter
		pkgs.zoxide
		pkgs.atuin
    pkgs.kubectl
    pkgs.sops
    pkgs.terraform
    pkgs.gitui
		pkgs.delta
		pkgs.gnupg
		pkgs.pinentry_mac
		pkgs.pinentry-curses
		pkgs.julia-mono
		pkgs.ruby_3_2
		pkgs.nerd-fonts.iosevka
		pkgs.nerd-fonts.hasklug
		pkgs.departure-mono
		pkgs.yq
		pkgs.shellcheck
		pkgs.pgcli
		pkgs.colima
		pkgs.cargo
		pkgs.zls
		pkgs.lldb
		pkgs.atac
		pkgs.zk
		pkgs.harper
		pkgs.glow
		pkgs.pipx
		pkgs.deno
		pkgs.skim
		pkgsUnstable.repomix
		pkgsUnstable.marksman
		pkgsUnstable._1password-cli
		pkgsUnstable.nodePackages_latest.nodejs
	];
	
  programs.htop.enable = true;
  programs.codex.enable = true;
  programs.claude-code.enable= true;
  programs.htop.settings.show_program_path = true;
	fonts.fontconfig.enable = true;

	programs.starship = {
    enable = true;
		settings = {
			shell = {
				disabled = false;
			};
		};
  };

	programs.wezterm = {
		enable = false;
		extraConfig = ''
			-- Pull in the wezterm API
			local wezterm = require 'wezterm'
			local config = {}
			-- In newer versions of wezterm, use the config_builder which will
			-- help provide clearer error messages
			if wezterm.config_builder then
			  config = wezterm.config_builder()
			end

			config.font = wezterm.font("JuliaMono", {weight="Regular", stretch="Normal", style="Normal"})
      config.font_size = 13.0
			config.color_scheme = 'Catppuccin Macchiato'
      config.cursor_blink_rate = 800
      config.window_decorations = "RESIZE"
      config.adjust_window_size_when_changing_font_size = false
      config.hide_tab_bar_if_only_one_tab = true
      config.front_end = "WebGpu"
			config.max_fps = 144
			config.leader = { key="a", mods="CTRL" }
			config.keys = {
		    { key = "a", mods = "LEADER|CTRL",  action=wezterm.action{SendString="\x01"}},
		    { key = "-", mods = "LEADER",       action=wezterm.action{SplitVertical={domain="CurrentPaneDomain"}}},
		    { key = "\\",mods = "LEADER",       action=wezterm.action{SplitHorizontal={domain="CurrentPaneDomain"}}},
		    { key = "s", mods = "LEADER",       action=wezterm.action{SplitVertical={domain="CurrentPaneDomain"}}},
		    { key = "v", mods = "LEADER",       action=wezterm.action{SplitHorizontal={domain="CurrentPaneDomain"}}},
		    { key = "o", mods = "LEADER",       action="TogglePaneZoomState" },
		    { key = "z", mods = "LEADER",       action="TogglePaneZoomState" },
		    { key = "c", mods = "LEADER",       action=wezterm.action{SpawnTab="CurrentPaneDomain"}},
		    { key = "h", mods = "LEADER",       action=wezterm.action{ActivatePaneDirection="Left"}},
		    { key = "j", mods = "LEADER",       action=wezterm.action{ActivatePaneDirection="Down"}},
		    { key = "k", mods = "LEADER",       action=wezterm.action{ActivatePaneDirection="Up"}},
		    { key = "l", mods = "LEADER",       action=wezterm.action{ActivatePaneDirection="Right"}},
		    { key = "H", mods = "LEADER|SHIFT", action=wezterm.action{AdjustPaneSize={"Left", 5}}},
		    { key = "J", mods = "LEADER|SHIFT", action=wezterm.action{AdjustPaneSize={"Down", 5}}},
		    { key = "K", mods = "LEADER|SHIFT", action=wezterm.action{AdjustPaneSize={"Up", 5}}},
		    { key = "L", mods = "LEADER|SHIFT", action=wezterm.action{AdjustPaneSize={"Right", 5}}},
		    { key = "1", mods = "LEADER",       action=wezterm.action{ActivateTab=0}},
		    { key = "2", mods = "LEADER",       action=wezterm.action{ActivateTab=1}},
		    { key = "3", mods = "LEADER",       action=wezterm.action{ActivateTab=2}},
		    { key = "4", mods = "LEADER",       action=wezterm.action{ActivateTab=3}},
		    { key = "5", mods = "LEADER",       action=wezterm.action{ActivateTab=4}},
		    { key = "6", mods = "LEADER",       action=wezterm.action{ActivateTab=5}},
		    { key = "7", mods = "LEADER",       action=wezterm.action{ActivateTab=6}},
		    { key = "8", mods = "LEADER",       action=wezterm.action{ActivateTab=7}},
		    { key = "9", mods = "LEADER",       action=wezterm.action{ActivateTab=8}},
		    { key = "&", mods = "LEADER|SHIFT", action=wezterm.action{CloseCurrentTab={confirm=true}}},
		    { key = "d", mods = "LEADER",       action=wezterm.action{CloseCurrentPane={confirm=true}}},
		    { key = "x", mods = "LEADER",       action=wezterm.action{CloseCurrentPane={confirm=true}}},
		  }

			return config
    '';
	};

	programs.kitty = {
		enable = false;
		settings = {
			font_family = "JuliaMono";
			bold_font = "JuliaMono Bold";
			italic_font = "JuliaMono RegularItalic";
			bold_italic_font = "JuliaMono SemiBoldItalic";
			font_size = "13.0";
			disable_ligatures = "cursor";
			window_padding_width = "0.5";
			tab_bar_min_tabs = 1;
			tab_fade = "0 0 0 0";
			tab_bar_edge = "top";
			tab_bar_style = "hidden";
			tab_title_template = "{f'{title[:30]}…' if title.rindex(title[-1]) + 1 > 30 else (title.center(6) if (title.rindex(title[-1]) + 1) % 2 == 0 else title.center(5))}";
		  active_tab_font_style = "bold-italic";
			inactive_tab_font_style = "normal";
			copy_on_select = "yes";
			enable_audio_bell = false;
			term = "xterm-kitty";
		};
		extraConfig = ''
			map ctrl+shift+; select_tab

      map ctrl+b>r load_config_file
      map ctrl+shift+2 send_text all \x00

      ### Layout operations ###
      # stack layout behaves the same as tmux pane zoom
      enabled_layouts splits,stack
      map ctrl+b>z toggle_layout stack
      map ctrl+b>space layout_action rotate

      ### Tab operations, corresponds to tmux window ###
      map ctrl+b>c new_tab
      map ctrl+b>& close_tab
      map ctrl+b>s new_tab_with_cwd

      map ctrl+b>w select_tab
      map ctrl+b>n next_tab
      map ctrl+b>p previous_tab
      map ctrl+b>0 goto_tab 1
      map ctrl+b>1 goto_tab 2
      map ctrl+b>2 goto_tab 3
      map ctrl+b>3 goto_tab 4
      map ctrl+b>4 goto_tab 5
      map ctrl+b>5 goto_tab 6
      map ctrl+b>6 goto_tab 7
      map ctrl+b>7 goto_tab 8
      map ctrl+b>8 goto_tab 9
      map ctrl+b>9 goto_tab 10

      # tmux sensible keybinding
      map ctrl+b>ctrl+p previous_tab
      map ctrl+b>ctrl+n next_tab

      ### Window operations, corresponds to tmux pane ###
      map ctrl+b>" launch --location=hsplit
      map ctrl+b>% launch --location=vsplit
      map ctrl+b>x close_window
      map ctrl+b>f new_window_with_cwd

      map ctrl+b>q focus_visible_window
      map ctrl+b>o next_window

      map ctrl+b>up neighboring_window up
      map ctrl+b>down neighboring_window down
      map ctrl+b>left neighboring_window left
      map ctrl+b>right neighboring_window right

      map ctrl+b>k neighboring_window up
      map ctrl+b>j neighboring_window down
      map ctrl+b>h neighboring_window left
      map ctrl+b>l neighboring_window right

      ### Tab bar
      tab_bar_edge                      bottom
      tab_bar_margin_height      0 7.5 
      tab_bar_style                       slant
      tab_bar_align                       left
      tab_title_max_length          27

      tab_title_template              " ⌘{index} {title[title.rfind('/')+1:]}"
      active_tab_title_template  " ⌘{index} {title[title.rfind('/')+1:]}"

      active_tab_font_style         normal

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
			wayland_titlebar_color  #24273A
			macos_titlebar_color    #24273A

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
			theme = "nordic";
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
		languages = {
		  use-grammars = { only = [ "ruby" "markdown" "javascript" "python" ]; };
		  language-server.ruby-lsp = with pkgs.ruby-lsp; {
				command = "ruby-lsp";
			};
			language-server.javascript = with pkgs.typescript-language-server; {
				command = "typescript-language-server";
				args = ["--stdio"];
			};
			language-server.nix = with pkgs.nil; {
				command = "nil";
			};
			language-server.markdown = with pkgs.marksman; {
				command = "marksman";
				args = ["server"];
			};
			language-server.jinja-lsp = with pkgsUnstable.jinja-lsp; {
				command = "jinja-lsp";
				config = { templates = "./templates"; backend = ["./src"]; lang = "rust";};
				timeout = 5;
			};
			language-server.scls = {
				command = "simple-completion-language-server";
			};
			language-server.scls.confg = {
				max_completion_items = 20;
				snippets_first = true;
				snippets_inline_by_word_tail = false;
				feature_words = true;
				feature_snippets = true;
				feature_unicode_input = true;
				feature_paths = true;
				feature_citations = false;
			};
			language-server.scls.environment = {
				RUST_LOG = "info,simple-completion-language-server=info";
				LOG_FILE = "/tmp/completion.log";
			};
			language-server.pylsp.config = {
			  pylsp.plugins.ruff.enabled = true;
				pylsp.plugins.black.enabled = true;
				pylsp.plugins.pylint.enabled = false;
				pylsp.plugins.pyflakes.enabled = false;
				pylsp.plugins.pyls_mypy.enabled = false;
				pylsp.plugins.pyls_mypy.live_mode = false;
				pylsp.plugins.isort.enabled = true;
				pylsp.plugins.rope_autoimport.enabled = true;
				pylsp.plugins.pycodestyle.maxLineLength = 120;
				pylsp.plugins.flake8.maxLineLength = 120;
			};
			language = [
				{
			    name = "rust";
			    auto-format = false;
					language-servers = [ "scls" "rust-analyzer" ];		  
				}
				{
					name = "git-commit";
					language-servers = [ "scls" ];
				}
				{
					name = "markdown";
					language-servers = ["scls" "markdown"];
				}
				{
					name = "python";
					language-servers = [ "pylsp" "scls"];
				}
				{
					name = "ruby";
					auto-format = false;
					comment-token = "#";
					file-types = ["rb" "rake" "rakefile" "irb" "gemfile" "gemspec" "Rakefile" "Gemfile" "rabl" "jbuilder" "jb"];
					language-servers = ["scls" "ruby-lsp"];
					roots = ["Gemfile.lock"];
					shebangs = ["ruby"];
					formatter.command = "stree";
					formatter.args = ["format"];
					indent.tab-width = 2;
					indent.unit = "  ";
				}
				{
					name = "html";
					scope = "text.html.basic";
					injection-regex = "html";
					file-types = ["html" "htm" "shtml" "xhtml" "xht" "jsp" "asp" "aspx" "jshtm" "volt" "rhtml"];
					roots = [];
					language-servers = [ "scls" "vscode-html-language-server" ];
					auto-format = true;
					indent.tab-width = 2;
					indent.unit = "  ";
				}
				{
					name = "stub";
					scope = "text.stub";
					file-types = [];
					shebangs = [];
					roots = [];
					auto-format = false;
					language-servers = [ "scls" ];
				}
				{
					name = "javascript";
					scope = "source.js";
					injection-regex = "(js|javascript)";
					language-id = "javascript";
					file-types = ["js" "mjs" "cjs" "rules" "es6" "pac" "jakefile"];
					shebangs = ["node"];
					roots = [];
					comment-token = "//";
					language-servers = [ "scls" "typescript-language-server" ];
				}
				{
					name = "jinja";
					language-servers = [ "jinja-lsp" ];
				}
			];
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
    withNodeJs = true;
    withPython3 = true;
    withRuby = true;
		extraConfig = ''
			lua require('init')
		'';
    extraPython3Packages = pkgs: [
      pkgs.pynvim
    ];
    extraPackages = with pkgs; [
			tree-sitter
			nodePackages.typescript nodePackages.typescript-language-server nodePackages.vscode-langservers-extracted nodePackages.yaml-language-server
			rubyPackages.syntax_tree
		];
		plugins = with pkgsUnstable.vimPlugins; [
			nvim-lspconfig
			blink-cmp
			dressing-nvim
			nui-nvim
			copilot-lua
			lspkind-nvim
			nvim-treesitter.withAllGrammars
			fzf-lua
			friendly-snippets
		  telescope-nvim		
			plenary-nvim
			nvim-autopairs
			nvim-comment
			indent-blankline-nvim
			gitsigns-nvim
			git-messenger-vim
			catppuccin-nvim
			mini-nvim
			nvim-neoclip-lua
			nvim-web-devicons
			leap-nvim
			lualine-nvim
			nvim-ts-autotag
			aerial-nvim
			blink-copilot
			(fromGitHub "151dbc23fe890d09c26df11b1208dd8129dca012" "main" "webhooked/kanso.nvim")
			codecompanion-nvim
			];
	};
	
  home.file.".config/nvim/lua".source = ./nvim/lua;

  programs.zsh = {
		enable = true;
		autocd = true;
		autosuggestion = {
			enable = true;
		};
		enableCompletion = true;
		syntaxHighlighting = {
      enable = true;
    };
		shellAliases = {
		  g = "git";
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
			ns = "nix-shell";
			docker = "podman";
      yawsso = "/Users/braidn/Library/Python/3.9/bin/yawsso";
		};
		
		initContent = ''
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
			export FZF_DEFAULT_COMMAND='sk'
			export FZF_DEFAULT_OPTS='--bind J:down,K:up --ansi '
			export NNN_OPENER='hx'
			export GPG_TTY=$(tty)
			export PNPM_HOME="/Users/braidn/Library/pnpm"cl
			export NODE_PATH=~/.npm-packages/lib/node_modules
			
			path+=('/Users/braidn/.rd/bin')
			path+=('/Users/braidn/.cargo/bin')
			path+=('/Users/braidn/.local/bin')
			path+=('/Users/braidn/.opencode/bin')
			path+=('/Users/braidn/.npm-packages/bin')
			path+=($PNPM_HOME)
			
			if [[ $TERM_PROGRAM != "WarpTerminal" ]]; then
				eval "$(atuin init zsh --disable-ctrl-r)"
			fi
			if [ -e '/Users/braidn/.config/op/plugins.sh' ]; then
				source /Users/braidn/.config/op/plugins.sh
			fi
		'';
	};
	
	programs.fzf = {
		enable = true;
		enableZshIntegration = true;
	};

	programs.zoxide = {
		enable = true;
		enableFishIntegration= true;
    enableZshIntegration = true;
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

  programs.bash = {
	  enable = true;
		shellAliases = {
			g = "git";
			v = "nvim";
			nv = "nvim";
			cwd = "pwd | pbcopy";
			le = "nnn -de";
			batl = "bat --paging=never -l log";
			be = "bundle exec";
			docker = "podman";
		};
	};

	programs.fish = {
		enable = false;
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
			docker = "podman";
		};
		shellInit = ''
		  set -U fish_term24bit 1
			set -U fish_greeting ""
			gpgconf --launch gpg-agent
		'';
		interactiveShellInit = ''
			set -Ux GPG_TTY (tty)
			set -Ux VISUAL "nvim -f"
			set -Ux EDITOR "nvim -f"
			set -Ux GIT_EDITOR "nvim -f"
			set -Ux AWS_SDK_LOAD_CONFIG true
			set -Ux PNPM_HOME "~/Library/pnpm"
			set -Ux LC_CTYPE "en_US.UTF-8"
			set -Ux LC_ALL "en_US.UTF-8"
			set -Ux CLICOLOR 1
			set -Ux NNN_OPENER "nvim -f"
			set -Ux AWS_PROFILE mine
			set -Ux KITTY_LISTEN_ON "unix:/tmp/mykitty"
			set -U fish_user_paths ~/.rd/bin $fish_user_paths
			set -U fish_user_paths ~/.opencode/bin $fish_user_paths			
			set -U fish_user_paths PNPM_HOME $fish_user_paths
			
			set fzf_fd_opts --hidden --exclude=.git
			
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
    EDITOR = "hx";
    TERMINAL = "term-256color tput colors";
	};

	programs.git = {
    enable = true;
		lfs.enable = true;
		userName = "Braden Douglass";
		userEmail = "braden.douglass@gmail.com";
		signing = {
			signByDefault = true;
			key = "";
		};
	  difftastic.enable = true;
    difftastic.color = "auto";
    difftastic.background = "dark";
    difftastic.enableAsDifftool = true;
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
			init.defaultBranch = "main";
			color.ui = "true";
			core = {
				whitespace = "fix,tab-in-indent,trailing-space,cr-at-eol";
			  editor = "nvim";
			  autocrlf = "input";
			  safecrlf = "warn";
				excludesFile = "~/.gitignore_global";
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
	home.stateVersion = "24.11";

# Let Home Manager install and manage itself.
	programs.home-manager.enable = true;
}

