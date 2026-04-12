-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({

    -- Common dependencies (eager)
    { "nvim-lua/plenary.nvim",       lazy = false },
    { "nvim-tree/nvim-web-devicons", lazy = false },
    { "MunifTanjim/nui.nvim",        lazy = false },

    -- Themes (all eager so they're available for the selector)
    { "shaunsingh/nord.nvim",  lazy = false, priority = 1000 },
    { "rose-pine/neovim",      lazy = false, priority = 1000, name = "rose-pine" },

    -- Auto dark/light mode based on macOS system appearance
    {
        "f-person/auto-dark-mode.nvim",
        lazy = false,
        priority = 999,
        config = function()
            require("auto-dark-mode").setup({
                update_interval = 3000,
                set_dark_mode = function()
                    vim.cmd("colorscheme nord")
                end,
                set_light_mode = function()
                    vim.cmd("colorscheme rose-pine-dawn")
                end,
            })
        end,
    },

    -- File explorer
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        cmd = "Neotree",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        },
        config = function()
            require("neo-tree").setup({
                filesystem = {
                    window = { position = "float" }
                }
            })
        end,
    },

    -- Fuzzy finder
    {
        "nvim-telescope/telescope.nvim",
        event = "VeryLazy",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("telescope").setup {
                defaults = {
                    layout_strategy = "vertical",
                    layout_config = { height = 0.8 },
                },
            }
        end,
    },

    -- Folding (eager — keymaps in settings.lua require it at startup)
    {
        "kevinhwang91/nvim-ufo",
        lazy = false,
        dependencies = { "kevinhwang91/promise-async" },
        config = function()
            require("ufo").setup({
                provider_selector = function(_, _, _)
                    return { "lsp", "indent" }
                end
            })
        end,
    },

    -- LSP: server installer
    {
        "williamboman/mason.nvim",
        cmd = "Mason",
        build = ":MasonUpdate",
        config = function()
            require("mason").setup()
        end,
    },

    -- LSP: bridge mason <-> lspconfig
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = { "pyright", "clangd", "ts_ls", "html", "vue_ls", "gopls", "lua_ls", "jsonls" },
                automatic_enable = false,
            })
        end,
    },

    -- LSP: server configs
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = { "saghen/blink.cmp", "williamboman/mason-lspconfig.nvim" },
        config = function()
            -- Pass blink.cmp capabilities to all servers
            vim.lsp.config("*", {
                capabilities = require("blink.cmp").get_lsp_capabilities(),
            })

            vim.lsp.config("lua_ls", {
                settings = {
                    Lua = {
                        runtime = { version = "LuaJIT" },
                        workspace = {
                            checkThirdParty = false,
                            library = vim.api.nvim_get_runtime_file("", true),
                        },
                        diagnostics = { globals = { "vim" } },
                    },
                },
            })

            vim.lsp.config("pyright", {
                settings = {
                    pyright = { disableOrganizeImports = true },
                    python = {
                        analysis = {
                            inlayHints = {
                                variableTypes = false,
                                parameterTypes = false,
                            },
                        },
                    },
                },
            })

            vim.lsp.config("clangd", {
                cmd = { "/usr/bin/clangd", "--fallback-style=none" },
                init_options = {
                    fallbackFlags = { "-std=c++17" },
                },
            })

            -- Rounded borders for all LSP floats (hover, diagnostics, signature)
            vim.o.winborder = "rounded"

            vim.lsp.enable({ "pyright", "clangd", "ts_ls", "html", "vue_ls", "gopls", "lua_ls", "jsonls" })

            -- Keymaps on attach
            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(ev)
                    local map = function(mode, lhs, rhs)
                        vim.keymap.set(mode, lhs, rhs, { silent = true, buffer = ev.buf })
                    end
                    map("n", "gd", vim.lsp.buf.definition)
                    map("n", "gy", vim.lsp.buf.type_definition)
                    map("n", "gi", vim.lsp.buf.implementation)
                    map("n", "gr", vim.lsp.buf.references)
                    map("n", "K", vim.lsp.buf.hover)
                    map("n", "<leader>e", vim.diagnostic.open_float)
                    map("n", "]d", vim.diagnostic.goto_next)
                    map("n", "[d", vim.diagnostic.goto_prev)
                    map("n", "<leader>rr", vim.lsp.buf.rename)
                    map({ "n", "x" }, "<leader>f", function()
                        require("conform").format({ bufnr = ev.buf, lsp_format = "fallback" })
                    end)
                end,
            })
        end,
    },

    -- Completion
    {
        "saghen/blink.cmp",
        version = "*",
        opts = {
            keymap = { preset = "super-tab" },
            sources = {
                default = { "lsp", "path", "buffer" },
            },
        },
    },

    -- Formatting
    {
        "stevearc/conform.nvim",
        event = "BufWritePre",
        config = function()
            require("conform").setup({
                formatters_by_ft = {
                    python     = { "ruff_fix", "ruff_format" },
                    cpp        = { "clang_format" },
                    c          = { "clang_format" },
                    javascript = { "prettier" },
                    typescript = { "prettier" },
                    vue        = { "prettier" },
                    htmldjango = { "djlint" },
                    json       = { "prettier" },
                    jsonc      = { "prettier" },
                    yaml       = { "prettier" },
                    markdown   = { "prettier" },
                    lua        = { "stylua" },
                },
                format_on_save = {
                    timeout_ms   = 500,
                    lsp_format = "fallback",
                },
            })
        end,
    },

    -- Smooth scrolling
    {
        "karb94/neoscroll.nvim",
        event = "VeryLazy",
        config = function()
            require("neoscroll").setup()
        end,
    },

    -- Markdown preview
    {
        "iamcco/markdown-preview.nvim",
        ft = "markdown",
        cmd = { "MarkdownPreview", "MarkdownPreviewStop", "MarkdownPreviewToggle" },
        build = function() vim.fn["mkdp#util#install"]() end,
    },

    -- Competitive programming
    {
        "xeluxee/competitest.nvim",
        cmd = "CompetiTest",
        dependencies = { "MunifTanjim/nui.nvim" },
        config = function()
            require("competitest").setup {
                run_command = {
                    python = { exec = "python3", args = { "$(FNAME)" } }
                }
            }
        end,
    },

    -- Terminal
    {
        "voldikss/vim-floaterm",
        cmd = { "FloatermToggle", "FloatermNew", "FloatermSend" },
        keys = { "<leader>t" },
    },

    -- Git diff view (eager — config mutates diffview internals before DiffviewOpen)
    {
        "sindrets/diffview.nvim",
        lazy = false,
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("diffview").setup({
                show_help_hints = false,
                file_panel = {
                    listing_style = "tree",
                },
                keymaps = {
                    file_panel = {
                        {
                            "n", "<CR>",
                            function()
                                require("diffview.actions").select_entry()
                                if vim.o.columns < 180 then
                                    require("diffview.actions").toggle_files()
                                end
                            end,
                            { desc = "Select entry, close panel if narrow" },
                        },
                    },
                },
                hooks = {
                    view_opened = function()
                        vim.t.diffview_file = "diffview"
                    end,
                    diff_buf_win_enter = function(bufnr, _, _)
                        local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":t")
                        if name ~= "" then
                            vim.t.diffview_file = name
                        end
                    end,
                    view_closed = function()
                        vim.t.diffview_file = nil
                    end,
                },
            })
            require("diffview.config").get_config().file_panel.win_config = function()
                if vim.o.columns >= 180 then
                    return { type = "split", position = "left", width = 35, win_opts = {} }
                else
                    return {
                        type = "float",
                        relative = "editor",
                        row = 1,
                        col = 0,
                        width = 35,
                        height = math.floor(vim.o.lines * 0.6),
                        zindex = 50,
                        border = "rounded",
                        win_opts = {},
                    }
                end
            end
            vim.api.nvim_set_hl(0, "DiffviewFilePanelRootPath", { link = "Ignore" })
            local dw = require("directory-watcher")
            dw.registerOnChangeHandler("diffview", function()
                local lib = require("diffview.lib")
                local view = lib.get_current_view()
                if view then view:update_files() end
            end)
            dw.setup({ path = vim.fn.getcwd() .. "/.git" })
        end,
    },

    -- Center pad
    { "smithbm2316/centerpad.nvim" },

    -- Buffer resize
    {
        "kwkarlwang/bufresize.nvim",
        event = "VeryLazy",
        config = function()
            require("bufresize").setup()
        end,
    },


    { "MeanderingProgrammer/render-markdown.nvim", ft = "markdown", enabled = false },
    { "HakonHarnes/img-clip.nvim",           event = "VeryLazy" },

    {
        "zbirenbaum/copilot.lua",
        event = "InsertEnter",
        dependencies = { "copilotlsp-nvim/copilot-lsp" },
    },

    { "esmuellert/codediff.nvim" },

    -- CSV viewer
    {
        "hat0uma/csvview.nvim",
        cmd = "CsvViewToggle",
        config = function()
            require("csvview").setup()
        end,
    },

}, {
    -- lazy.nvim options
    install = { colorscheme = { "nord" } },
    checker = { enabled = false },
})
