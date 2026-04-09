{ pkgs, ... }:
let
  sources = pkgs.callPackage ../../../_sources/generated.nix { };
  buildVimPlugin = name: src: pkgs.vimUtils.buildVimPlugin { inherit name src; };

  vim-dmacro = buildVimPlugin "vim-dmacro" sources.vim-dmacro.src;
  vim-quickhl = buildVimPlugin "vim-quickhl" sources.vim-quickhl.src;
  eskk-vim = buildVimPlugin "eskk-vim" sources.eskk-vim.src;
  skkdict-vim = buildVimPlugin "skkdict-vim" sources.skkdict-vim.src;
  hackshark-nvim = buildVimPlugin "hackshark-nvim" sources.hackshark-nvim.src;
  vim-capture = buildVimPlugin "vim-capture" sources.vim-capture.src;
  vim-linediff = buildVimPlugin "vim-linediff" sources.vim-linediff.src;

  # Colorschemes from nvfetcher
  vim-voir = buildVimPlugin "vim-voir" sources.vim-voir.src;
  vim-seoul256 = buildVimPlugin "vim-seoul256" sources.vim-seoul256.src;
  vim-edge = buildVimPlugin "vim-edge" sources.vim-edge.src;
  vim-onedark = buildVimPlugin "vim-onedark" sources.vim-onedark.src;
  vim-molokai = buildVimPlugin "vim-molokai" sources.vim-molokai.src;
  vim-dichromatic = buildVimPlugin "vim-dichromatic" sources.vim-dichromatic.src;
  vim-tatami = buildVimPlugin "vim-tatami" sources.vim-tatami.src;
  vim-lucius = buildVimPlugin "vim-lucius" sources.vim-lucius.src;

  # Build merged SKK dictionary at build time! ✨
  merged-skk-jisyo = pkgs.stdenv.mkDerivation {
    name = "merged-skk-jisyo";
    nativeBuildInputs = [ pkgs.skktools ];
    dicts = with pkgs.skkDictionaries; [
      l
      jinmei
      geo
      station
      propernoun
      zipcode
    ];
    unpackPhase = "true";
    installPhase = ''
      mkdir -p $out
      args=""
      for dict in $dicts; do
        jisyo=$(find $dict -name "SKK-JISYO.*" | head -n 1)
        if [ -n "$args" ]; then
          args="$args + $jisyo"
        else
          args="$jisyo"
        fi
      done
      skkdic-expr2 $args > $out/SKK-JISYO.L
    '';
  };
in
{
  # Link the merged dictionary to the expected path 💎
  home.file.".local/share/nvim/eskk/SKK-JISYO.L".source = "${merged-skk-jisyo}/SKK-JISYO.L";

  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    # Basic Options
    opts = {
      number = true;
      wrap = false;
      list = true;
      listchars = "tab:│─,trail:-,nbsp:+,extends:»,precedes:«";
      colorcolumn = "80";
      cursorline = true;
      breakindent = true;
      showbreak = "↪";
      ignorecase = true;
      smartcase = true;
      inccommand = "split";
      expandtab = true;
      shiftwidth = 4;
      tabstop = 4;
      softtabstop = 4;
      clipboard = "unnamedplus";
      mouse = "a";
      updatetime = 500;
      confirm = true;
      exrc = true;
      laststatus = 2;
      showmode = false;
    };

    diagnostic.settings = {
      severity_sort = true;
      virtual_text = {
        # source = "if_many";
      };
      jump = {
        on_jump.__raw = ''
          function(_, bufnr)
            vim.diagnostic.open_float { bufnr = bufnr, scope = 'cursor', focus = false }
          end
        '';
      };
      float = {
        # source = "if_many";
        border = "single";
        title = "Diagnostics";
        header = { };
        suffix = { };
        format.__raw = ''
          function(diag)
            if diag.code then
              return string.format('[%s](%s): %s', diag.source, diag.code, diag.message)
            else
              return string.format('[%s]: %s', diag.source, diag.message)
            end
          end
        '';
      };
    };

    # Global Keymaps
    keymaps = [
      {
        mode = "i";
        key = "jj";
        action = "<Esc>";
        options.silent = true;
      }
      {
        mode = "t";
        key = "jj";
        action = "<C-\\><C-n>";
      }
      {
        mode = "n";
        key = "<Space>tig";
        action = "<Cmd>tabnew<CR><Cmd>te tig<CR><Cmd>tunmap <buffer> jj<CR>i";
        options.silent = true;
      }
      # SKK
      {
        mode = [
          "i"
          "c"
        ];
        key = "<C-j>";
        action = "<Plug>(eskk:enable)";
      }
      # Snacks.nvim Picker Keymaps
      {
        mode = "n";
        key = "<Space><Space>";
        action.__raw = "function() Snacks.picker() end";
        options.desc = "Picker";
      }
      {
        mode = "n";
        key = "<Space>fh";
        action.__raw = "function() Snacks.picker.help() end";
        options.desc = "Help";
      }
      {
        mode = "n";
        key = "<Space>ff";
        action.__raw = "function() Snacks.picker.smart({ multi = { 'buffers', 'files' } }) end";
        options.desc = "Smart Find Files";
      }
      {
        mode = "n";
        key = "<Space>f/";
        action.__raw = "function() Snacks.picker.grep() end";
        options.desc = "Grep";
      }
      {
        mode = "n";
        key = "<Space>f:";
        action.__raw = "function() Snacks.picker.command_history() end";
        options.desc = "Command History";
      }
      {
        mode = "n";
        key = "<Space>fr";
        action.__raw = "function() Snacks.picker.resume() end";
        options.desc = "Resume";
      }
      {
        mode = "n";
        key = "<Space>fb";
        action.__raw = "function() Snacks.picker.buffers() end";
        options.desc = "Buffers";
      }
      {
        mode = "n";
        key = "<Space>fg";
        action.__raw = "function() Snacks.picker.git_files({ untracked = true }) end";
        options.desc = "Find Git Files";
      }
      {
        mode = "n";
        key = "<Space>/";
        action.__raw = "function() Snacks.picker.lines() end";
        options.desc = "Buffer Lines";
      }
      # ToggleTerm
      {
        mode = "n";
        key = "<Space>nt";
        action = "<Cmd>ToggleTerm<CR>";
        options.desc = "Toggle Terminal";
      }
      {
        mode = "n";
        key = "<Space>nn";
        action = "<Cmd>ToggleTermSendCurrentLine<CR>";
        options.desc = "Send current line to terminal";
      }
      {
        mode = "x";
        key = "<Space>nn";
        action = "<Cmd>ToggleTermSendVisualSelection<CR>";
        options.desc = "Send visual selection to terminal";
      }
      # NvimTree
      {
        mode = "n";
        key = "<Space>ft";
        action = "<Cmd>NvimTreeToggle<CR>";
        options.desc = "Toggle File Tree";
      }
      # dmacro
      {
        mode = [
          "i"
          "n"
        ];
        key = "<M-q>";
        action = "<Plug>(dmacro-play-macro)";
        options.desc = "Dmacro play macro";
      }
      # quickhl
      {
        mode = "n";
        key = "<Space>hl";
        action = "<Plug>(quickhl-manual-this)";
        options.desc = "Quickhl manual this";
      }
      {
        mode = "n";
        key = "<Space>nohl";
        action = "<Plug>(quickhl-manual-reset)";
        options.desc = "Quickhl manual reset";
      }
    ];

    # Auto Commands
    autoCmd = [
      {
        event = "TermOpen";
        pattern = "*";
        command = "setlocal nonumber norelativenumber";
      }
      {
        event = "VimResized";
        pattern = "*";
        command = "wincmd =";
      }
      {
        event = "QuickfixCmdPost";
        pattern = "*";
        command = "if !empty(getqflist()) | copen | endif";
      }
    ];

    # Plugins
    plugins = {
      # NvimTree
      nvim-tree = {
        enable = true;
        settings = {
          hijack_netrw = false;
          actions = {
            open_file = {
              quit_on_open = true;
            };
          };
        };
      };

      # Treesitter & Friends
      treesitter = {
        enable = true;
        settings = {
          highlight.enable = true;
          indent.enable = true;
        };
      };
      treesitter-textobjects = {
        enable = true;
        settings.select = {
          enable = true;
          lookahead = true;
          keymaps = {
            "af" = "@function.outer";
            "if" = "@function.inner";
          };
          selection_modes = {
            "@function.outer" = "V";
          };
        };
      };
      ts-autotag.enable = true;
      ts-context-commentstring = {
        enable = true;
        settings.enable_autocmd = false;
      };
      comment = {
        enable = true;
        settings.pre_hook = ''
          require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook()
        '';
      };
      matchup = {
        enable = true;
        settings.matchparen_offscreen.method = "popup";
      };
      treesj = {
        enable = true;
        settings.use_default_keymaps = false;
      };

      # LSP
      lsp = {
        enable = true;
        servers = {
          denols = {
            enable = true;
            package = null;
          };
          jsonls = {
            enable = true;
            package = null;
          };
          yamlls = {
            enable = true;
            package = null;
          };
        };
        keymaps = {
          silent = true;
          diagnostic = {
            "<space>e" = "open_float";
            "<space>ql" = "setqflist";
            "<space>ll" = "setloclist";
          };
          lspBuf = {
            "gD" = "declaration";
            "gd" = "definition";
            "K" = "hover";
            "gI" = "implementation";
            "<C-k>" = "signature_help";
            "<space>D" = "type_definition";
            "<space>rn" = "rename";
            "<space>ca" = "code_action";
            "gr" = "references";
            "<space>lf" = "format";
          };
        };
      };
      schemastore.enable = true;
      lsp-signature-help.enable = true;

      # Completion
      cmp = {
        enable = true;
        settings = {
          mapping = {
            "<C-b>" = "cmp.mapping.scroll_docs(-4)";
            "<C-f>" = "cmp.mapping.scroll_docs(4)";
            "<Space>" = "cmp.mapping.confirm({ select = true })";
            "<Tab>" =
              "cmp.mapping(function(fallback) if vim.snippet.active({ direction = 1 }) then vim.snippet.jump(1) else fallback() end end, {'i', 's'})";
            "<S-Tab>" =
              "cmp.mapping(function(fallback) if vim.snippet.active({ direction = -1 }) then vim.snippet.jump(-1) else fallback() end end, {'i', 's'})";
          };
          sources = [
            { name = "nvim_lsp"; }
            { name = "path"; }
            { name = "buffer"; }
          ];
        };
      };

      lspkind = {
        enable = true;
        cmp.enable = true;
      };

      # Snacks
      snacks = {
        enable = true;
        settings = {
          picker.enabled = true;
          input.enabled = true;
          styles.input.relative = "cursor";
        };
      };

      # Telescope
      telescope = {
        enable = true;
        settings.defaults = {
          layout_config.horizontal.prompt_position = "top";
          sorting_strategy = "ascending";
        };
        extensions = {
          fzf-native.enable = true;
          file-browser.enable = true;
        };
      };

      # UI
      lualine = {
        enable = true;
        settings = {
          options = {
            icons_enabled = false;
            section_separators = "";
            component_separators = "";
          };
          sections.lualine_a = [
            {
              __raw = ''
                function()
                  if vim.g.loaded_eskk ~= 1 then return "" end
                  if vim.fn.mode() ~= "i" then return "" end
                  if vim.fn["eskk#is_enabled"]() == 0 then return "" end
                  return vim.g["eskk#statusline_mode_strings"][vim.fn["eskk#get_mode"]()]
                end
              '';
            }
            "mode"
          ];
          extensions = [
            "aerial"
            "man"
            "oil"
            "quickfix"
            "trouble"
          ];
        };
      };

      gitsigns = {
        enable = true;
        settings = {
          signs = {
            add.text = "+";
            change.text = "│";
            delete.text = "_";
            topdelete.text = "‾";
            changedelete.text = "~";
            untracked.text = "┆";
          };
          signs_staged_enable = false;
        };
      };

      indent-blankline = {
        enable = true;
        settings = {
          indent.char = "│";
          scope.enabled = false;
        };
      };

      # Utilities
      oil.enable = true;
      trouble.enable = true;
      aerial.enable = true;
      nvim-autopairs.enable = true;
      fidget.enable = true;
      markdown-preview.enable = true;
      toggleterm = {
        enable = true;
        settings.direction = "float";
      };
      nvim-surround.enable = true;
      dial.enable = true;
      quicker.enable = true;
      illuminate.enable = true;
      web-devicons.enable = true;
      bqf.enable = true;
      scrollbar = {
        enable = true;
        handlers.gitsigns = true;
      };
      dropbar.enable = true;
      notify.enable = true;
      nvim-colorizer.enable = true;

      # Format & Lint
      conform-nvim = {
        enable = true;
        settings = {
          default_format_opts.lsp_format = "fallback";
          format_on_save.lsp_format = "fallback";
          formatters_by_ft = {
            lua = [ "stylua" ];
            bash = [ "shfmt" ];
            fish = [ "fish_indent" ];
            go = [
              "goimports"
              "gofmt"
            ];
            javascript = [ "prettier" ];
            typescript = [ "prettier" ];
            markdown = [
              "prettier"
              "injected"
            ];
            python = [ "ruff_format" ];
          };
        };
      };

      none-ls = {
        enable = true;
        sources = {
          diagnostics = {
            hadolint.enable = true;
            gitlint.enable = true;
            actionlint.enable = true;
            checkmake.enable = true;
            markdownlint.enable = true;
            vint.enable = true;
          };
        };
      };

      # Debug & Test
      dap.enable = true;
      neotest = {
        enable = true;
        adapters.plenary.enable = true;
      };
    };

    # Colorschemes
    colorschemes.catppuccin = {
      enable = true;
      settings.flavour = "mocha";
    };

    # Extra Plugins
    extraPlugins = [
      vim-dmacro
      vim-quickhl
      eskk-vim
      skkdict-vim
      hackshark-nvim
      vim-capture
      vim-linediff
      pkgs.vimPlugins.catppuccin-nvim
      pkgs.vimPlugins.tokyonight-nvim
      pkgs.vimPlugins.kanagawa-nvim
      pkgs.vimPlugins.Recover-vim
      pkgs.vimPlugins.open-browser-vim
      pkgs.vimPlugins.cellular-automaton-nvim
      pkgs.vimPlugins.nvim_context_vt
      pkgs.vimPlugins.nvim-ts-context-commentstring
      vim-voir
      vim-seoul256
      vim-edge
      vim-onedark
      vim-molokai
      vim-dichromatic
      vim-tatami
      vim-lucius
    ];

    # Extra Lua Config (Read from separate file)
    extraConfigLua = builtins.readFile ./config.lua;

    # Extra Packages
    extraPackages = with pkgs; [
      neovim-remote
      gcc
      gitlint
      tree-sitter
      ripgrep
      fd
      stylua
      shfmt
      shellcheck
      hadolint
      actionlint
      checkmake
      markdownlint-cli
      ruff
    ];
  };
}
