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
end)
