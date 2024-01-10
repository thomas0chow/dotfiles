-- Editor options

vim.opt.number = true
vim.opt.clipboard = "unnamedplus"
vim.opt.syntax = "on"
vim.opt.autoindent = true
vim.opt.cursorline = true
vim.opt.expandtab = true

vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.api.nvim_create_autocmd("FileType", {
    pattern = "javascript",
    command = "setlocal shiftwidth=2 tabstop=2"
})
vim.api.nvim_create_autocmd("FileType", {
    pattern = "typescript",
    command = "setlocal shiftwidth=2 tabstop=2"
})

vim.opt.encoding = "UTF-8"
vim.opt.ruler = true
vim.opt.mouse = "a"
vim.opt.title = true
vim.opt.hidden = true
vim.opt.ttimeoutlen = 0
vim.opt.wildmenu = true
vim.opt.showcmd = true
vim.opt.showmatch = true
vim.opt.inccommand = "split"
vim.o.swapfile = "false"

-- Plug settings

-- coc
vim.g.coc_global_extensions = { "coc-go", "coc-pyright", "coc-json", "coc-prettier", "coc-tsserver", "coc-spell-checker",
    "coc-docker", "coc-git", "coc-lua", "@yaegassy/coc-nginx", "coc-yaml", "coc-clangd", "coc-r-lsp",
    "@yaegassy/coc-ruff", "coc-htmldjango", "coc-html", "coc-css", "coc-sql", "@yaegassy/coc-volar",
    "@yaegassy/coc-volar-tools" }

local keyset = vim.keymap.set

function _G.check_back_space()
    local col = vim.fn.col(".") - 1
    return col == 0 or vim.fn.getline("."):sub(col, col):match("%s") ~= nil
end

local opts = { silent = true, noremap = true, expr = true, replace_keycodes = false }
keyset("i", "<TAB>", 'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()', opts)
keyset("i", "<S-TAB>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)

keyset("i", "<cr>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], opts)

function _G.show_docs()
    local cw = vim.fn.expand("<cword>")
    if vim.fn.index({ "vim", "help" }, vim.bo.filetype) >= 0 then
        vim.api.nvim_command("h " .. cw)
    elseif vim.api.nvim_eval("coc#rpc#ready()") then
        vim.fn.CocActionAsync("doHover")
    else
        vim.api.nvim_command("!" .. vim.o.keywordprg .. " " .. cw)
    end
end

keyset("n", "K", "<CMD>lua _G.show_docs()<CR>", { silent = true })

keyset("n", "<leader>rr", "<Plug>(coc-rename)", { silent = true })

keyset("n", "gd", "<Plug>(coc-definition)", { silent = true })
keyset("n", "gy", "<Plug>(coc-type-definition)", { silent = true })
keyset("n", "gi", "<Plug>(coc-implementation)", { silent = true })
keyset("n", "gr", "<Plug>(coc-references)", { silent = true })

-- Formating
keyset("x", "<leader>f", "<Plug>(coc-format-selected)", { silent = true })
keyset("n", "<leader>f", "<Plug>(coc-format-selected)", { silent = true })
vim.api.nvim_create_user_command("Format", "call CocAction('format')", {})
vim.cmd [[autocmd BufWritePre *.cc,*.hh : call CocAction('format')]]

-- nvim-ufo
vim.o.foldcolumn = '1' -- '0' is not bad
vim.o.foldlevel = 99   -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true

keyset('n', 'zR', require('ufo').openAllFolds)
keyset('n', 'zM', require('ufo').closeAllFolds)

-- neo-tree
keyset("n", "<leader>bb", ":NeoTreeShow<CR>", { silent = true })

-- floaterm
vim.g.floaterm_keymap_toggle = "<leader>t"

-- django html template
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.html",
    callback = function()
        if vim.bo.filetype == "htmldjango" then
            vim.cmd("CocCommand htmldjango.djlint.format")
        end
    end
})
