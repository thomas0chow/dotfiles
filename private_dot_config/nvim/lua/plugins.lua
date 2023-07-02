-- Automatically run: PackerCompile
vim.api.nvim_create_autocmd("BufWritePost", {
    group = vim.api.nvim_create_augroup("PACKER", { clear = true }),
    pattern = "plugins.lua",
    command = "source <afile> | PackerCompile",
})

return require("packer").startup(function(use)
    -- Packer
    use("wbthomason/packer.nvim")

    -- Common utilities
    use("nvim-lua/plenary.nvim")

    -- Icons
    use("nvim-tree/nvim-web-devicons")

    -- Colorschema
    use("shaunsingh/nord.nvim")

    -- File manager
    use({
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v2.x",
        requires = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        },
    })

    -- Telescope
    use({
        "nvim-telescope/telescope.nvim",
        tag = "0.1.1",
        requires = {
            "nvim-lua/plenary.nvim"
        },
    })

    -- Folder
    use({
        'kevinhwang91/nvim-ufo',
        requires = 'kevinhwang91/promise-async'
    })


    -- coc
    use({
        "neoclide/coc.nvim",
        branch = "release",
    })
    require("ufo").setup()

    -- Scroll
    use('karb94/neoscroll.nvim')
    require('neoscroll').setup()

    -- Markdown Preview
    -- install without yarn or npm
    use({
        "iamcco/markdown-preview.nvim",
        run = function() vim.fn["mkdp#util#install"]() end,
    })

    -- competitest
    use {
        'xeluxee/competitest.nvim',
        requires = 'MunifTanjim/nui.nvim',
    }
    require('competitest').setup {
        run_command = {
            python = { exec = "python3", args = { "$(FNAME)" } }
        }
    }

    -- Firenvim
    use {
        'glacambre/firenvim',
        run = function() vim.fn['firenvim#install'](0) end
    }
end)
