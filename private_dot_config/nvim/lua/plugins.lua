-- Automatically run: PackerCompile
vim.api.nvim_create_autocmd("BufWritePost", {
    group = vim.api.nvim_create_augroup("PACKER", { clear = true }),
    pattern = "plugins.lua",
    command = "source <afile> | PackerCompile",
})

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
            require('telescope').setup {
                defaults = {
                    layout_strategy = 'vertical',
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
            require('ufo').setup({
                provider_selector = function(bufnr, filetype, buftype)
                    return { 'treesitter', 'indent' }
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
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup()
        end
    })

    -- Terminal
    use("voldikss/vim-floaterm")

    -- Git diff view
    use("sindrets/diffview.nvim")

    -- Center pad
    use('smithbm2316/centerpad.nvim')

    -- Buffer resize
    use({
        "kwkarlwang/bufresize.nvim",
        config = function()
            require("bufresize").setup()
        end
    })


    local is_personal_machine = vim.fn.hostname() == "bronzeage.local"

    -- Copilot Chat
    use({
        'CopilotC-Nvim/CopilotChat.nvim',
        disable = is_personal_machine,
        requires = {
            { 'github/copilot.vim' },
            { 'nvim-lua/plenary.nvim', branch = 'master' },
        },
        run = "make tiktoken",
        config = function()
            require("CopilotChat").setup({
                model = "claude-3.7-sonnet-thought",
                chat_autocomplete = false
            })
        end
    })


    -- Avante
    use 'nvim-treesitter/nvim-treesitter'
    use 'stevearc/dressing.nvim'
    use 'MeanderingProgrammer/render-markdown.nvim'
    use 'hrsh7th/nvim-cmp'
    use 'HakonHarnes/img-clip.nvim'
    use 'zbirenbaum/copilot.lua'

    use {
        'yetone/avante.nvim',
        disable = not is_personal_machine,
        branch = 'main',
        run = 'make',
        config = function()
            require('avante').setup({
                claude = {
                    model = "claude-3-7-sonnet-20250219"
                },
                behaviour = {
                    auto_suggestions = true,
                }
            })
        end
    }
end)
