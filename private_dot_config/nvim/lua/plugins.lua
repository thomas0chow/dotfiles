-- Automatically run: PackerCompile
vim.api.nvim_create_autocmd("BufWritePost", {
    group = vim.api.nvim_create_augroup("PACKER", { clear = true }),
    pattern = "plugins.lua",
    command = "source <afile> | PackerCompile",
})

-- Auto PackerCompile if plugins.lua is newer than packer_compiled.lua
local plugins_file = vim.fn.stdpath("config") .. "/lua/plugins.lua"
local compiled_file = vim.fn.stdpath("config") .. "/plugin/packer_compiled.lua"
local plugins_mtime = vim.uv.fs_stat(plugins_file)
local compiled_mtime = vim.uv.fs_stat(compiled_file)
if not compiled_mtime or (plugins_mtime and plugins_mtime.mtime.sec > compiled_mtime.mtime.sec) then
    vim.api.nvim_create_autocmd("VimEnter", {
        once = true,
        callback = function()
            require("packer").compile()
        end,
    })
end

return require("packer").startup(function(use)
    -- Packer can manage itself
    use("wbthomason/packer.nvim")

    -- Common dependencies
    use("nvim-lua/plenary.nvim")
    use("nvim-tree/nvim-web-devicons")
    use("MunifTanjim/nui.nvim")

    -- Theme
    use("shaunsingh/nord.nvim")

    -- File explorer
    use({
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        requires = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        },
        config = function()
            require("neo-tree").setup({
                filesystem = {
                    window = {
                        position = "float"
                    }
                }
            })
        end
    })

    -- Fuzzy finder
    use({
        "nvim-telescope/telescope.nvim",
        tag = "0.1.4",
        requires = { "nvim-lua/plenary.nvim" },
        config = function()
            require("telescope").setup {
                defaults = {
                    layout_strategy = "vertical",
                    layout_config = { height = 0.8 },
                },
            }
        end
    })

    -- Folding
    use({
        "kevinhwang91/nvim-ufo",
        requires = "kevinhwang91/promise-async",
        config = function()
            require("ufo").setup({
                provider_selector = function(bufnr, filetype, buftype)
                    return { "treesitter", "indent" }
                end
            })
        end
    })

    -- Completion
    use({
        "neoclide/coc.nvim",
        branch = "release",
    })

    -- Smooth scrolling
    use({
        "karb94/neoscroll.nvim",
        config = function()
            require("neoscroll").setup()
        end
    })

    -- Markdown preview
    use({
        "iamcco/markdown-preview.nvim",
        run = function() vim.fn["mkdp#util#install"]() end,
    })

    -- Competitive programming
    use({
        "xeluxee/competitest.nvim",
        requires = "MunifTanjim/nui.nvim",
        config = function()
            require("competitest").setup {
                run_command = {
                    python = { exec = "python3", args = { "$(FNAME)" } }
                }
            }
        end
    })

    -- Commenting
    use({
        "numToStr/Comment.nvim",
        config = function()
            require("Comment").setup()
        end
    })

    -- Terminal
    use("voldikss/vim-floaterm")

    -- Git diff view
    use({
        "sindrets/diffview.nvim",
        requires = "nvim-lua/plenary.nvim",
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
            -- Dynamic file panel: floating when narrow, split when wide
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
            -- Hide the cwd root path line (no config option exists for it)
            vim.api.nvim_set_hl(0, "DiffviewFilePanelRootPath", { link = "Ignore" })

            -- Watch .git/ for changes and refresh diffview automatically
            local dw = require("directory-watcher")
            dw.registerOnChangeHandler("diffview", function()
                local lib = require("diffview.lib")
                local view = lib.get_current_view()
                if view then
                    view:update_files()
                end
            end)
            dw.setup({ path = vim.fn.getcwd() .. "/.git" })
        end
    })

    -- Center pad
    use("smithbm2316/centerpad.nvim")

    -- Buffer resize
    use({
        "kwkarlwang/bufresize.nvim",
        config = function()
            require("bufresize").setup()
        end
    })



    use({
        "nvim-treesitter/nvim-treesitter",
        branch = "master",
        run = function() vim.cmd("TSUpdate") end,
    })
    use "stevearc/dressing.nvim"
    use "MeanderingProgrammer/render-markdown.nvim"
    use "hrsh7th/nvim-cmp"
    use "HakonHarnes/img-clip.nvim"

    use({
        "zbirenbaum/copilot.lua",
        requires = {
            "copilotlsp-nvim/copilot-lsp", -- (optional) for NES functionality
        }
    })

    use("esmuellert/codediff.nvim")

    -- CSV viewer
    use({
        "hat0uma/csvview.nvim",
        config = function()
            require("csvview").setup()
        end
    })
end)
