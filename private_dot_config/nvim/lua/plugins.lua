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

    -- Theme
    {
        "shaunsingh/nord.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd("colorscheme nord")
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
        tag = "0.1.4",
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
                    return { "treesitter", "indent" }
                end
            })
        end,
    },

    -- Completion / LSP
    {
        "neoclide/coc.nvim",
        branch = "release",
        event = "BufReadPre",
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

    -- Commenting
    {
        "numToStr/Comment.nvim",
        keys = {
            { "gc", mode = { "n", "v" } },
            { "gb", mode = { "n", "v" } },
        },
        config = function()
            require("Comment").setup()
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

    -- Treesitter (eager — core syntax highlighting)
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        branch = "master",
        build = function() vim.cmd("TSUpdate") end,
    },

    { "stevearc/dressing.nvim",              event = "VeryLazy" },
    { "MeanderingProgrammer/render-markdown.nvim", ft = "markdown" },
    { "hrsh7th/nvim-cmp",                    event = "InsertEnter" },
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
