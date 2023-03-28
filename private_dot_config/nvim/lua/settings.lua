-- Editor options

vim.opt.number = true
vim.opt.clipboard = "unnamedplus"
vim.opt.syntax = "on"
vim.opt.autoindent = true
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
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

-- Plug settings

-- vim-autoformat
-- vim.g.autoformat_verbosemode = 1
-- vim.g.formatters_python = {"yapf"}
-- vim.g.formatters_go = {"goimports", "gofmt_2"}
-- vim.g.run_all_formatters_go = 1
-- vim.g.formatters_lua = {"luafmt"}
-- vim.g.formatters_json = {"prettier"}

-- coc
vim.g.coc_global_extensions = { "coc-go", "coc-pyright", "coc-json", "coc-prettier", "coc-tsserver", "coc-spell-checker",
    "coc-docker", "coc-git", "coc-lua", "@yaegassy/coc-nginx", "coc-yaml" }

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