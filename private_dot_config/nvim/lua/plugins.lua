-- Automatically run: PackerCompile
vim.api.nvim_create_autocmd("BufWritePost", {
    group = vim.api.nvim_create_augroup("PACKER", { clear = true }),
    pattern = "plugins.lua",
    command = "source <afile> | PackerCompile",
})

return require("packer").startup(function(use)
    use("wbthomason/packer.nvim")

    use("nvim-lua/plenary.nvim")

    use("nvim-tree/nvim-web-devicons")
    use("shaunsingh/nord.nvim")

    use({
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        requires = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        },
    })

    require("neo-tree").setup({
        filesystem = {
            window = {
                position = "float"
            }
        }
    })

    use({
        "nvim-telescope/telescope.nvim",
        tag = "0.1.4",
        requires = {
            "nvim-lua/plenary.nvim"
        },
    })

    require('telescope').setup {
        defaults = {
            layout_strategy = 'vertical',
            layout_config = { height = 0.8 },
        },
    }

    use({
        "kevinhwang91/nvim-ufo",
        requires = "kevinhwang91/promise-async"
    })
    require('ufo').setup({
        provider_selector = function(bufnr, filetype, buftype)
            return { 'treesitter', 'indent' }
        end
    })

    use({
        "neoclide/coc.nvim",
        branch = "release",
    })

    use("karb94/neoscroll.nvim")
    require("neoscroll").setup()

    use({
        "iamcco/markdown-preview.nvim",
        run = function() vim.fn["mkdp#util#install"]() end,
    })

    use {
        "xeluxee/competitest.nvim",
        requires = "MunifTanjim/nui.nvim",
    }
    require("competitest").setup {
        run_command = {
            python = { exec = "python3", args = { "$(FNAME)" } }
        }
    }

    use('numToStr/Comment.nvim')
    require('Comment').setup()

    use "voldikss/vim-floaterm"

    use("sindrets/diffview.nvim")

    use { 'smithbm2316/centerpad.nvim' }

    use {
        "kwkarlwang/bufresize.nvim",
        config = function()
            require("bufresize").setup()
        end
    }
end)
