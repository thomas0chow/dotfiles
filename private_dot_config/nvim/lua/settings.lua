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
    pattern = { "javascript", "typescript", "vue" },
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
vim.o.swapfile = false

local keyset = vim.keymap.set

-- nvim-ufo
vim.o.foldcolumn = '1' -- '0' is not bad
vim.o.foldlevel = 99   -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]

keyset('n', 'zR', require('ufo').openAllFolds)
keyset('n', 'zM', require('ufo').closeAllFolds)
keyset('n', 'zr', require('ufo').openFoldsExceptKinds)
keyset('n', 'zm', require('ufo').closeFoldsWith) -- closeAllFolds == closeFoldsWith(0)

-- neo-tree
keyset("n", "<leader>bb", ":Neotree toggle<CR>", { silent = true })

-- floaterm
vim.g.floaterm_keymap_toggle = "<leader>t"
vim.g.floaterm_wintype = "split"
vim.g.floaterm_height = 0.25
vim.g.floaterm_shell = "env LANG=en_US.UTF-8 zsh"

-- CsvView
keyset("n", "<leader>cv", ":CsvViewToggle<CR>", { silent = true })

-- Custom tabline: show diffview current file name on diffview tab
function _G.MyTabLine()
    local s = ""
    for i = 1, vim.fn.tabpagenr("$") do
        local title = vim.fn.gettabvar(i, "diffview_file", "")
        if title == "" then
            local buflist = vim.fn.tabpagebuflist(i)
            local winnr = vim.fn.tabpagewinnr(i)
            local bufnr = buflist[winnr]
            title = vim.fn.fnamemodify(vim.fn.bufname(bufnr), ":t")
            if title == "" then title = "[No Name]" end
        end
        local modified = ""
        for _, buf in ipairs(vim.fn.tabpagebuflist(i)) do
            if vim.fn.getbufvar(buf, "&modified") == 1 then
                modified = " ●"
                break
            end
        end
        if i == vim.fn.tabpagenr() then
            s = s .. "%#TabLineSel# " .. title .. modified .. " "
        else
            s = s .. "%#TabLine# " .. title .. modified .. " "
        end
    end
    return s .. "%#TabLineFill#"
end
vim.opt.tabline = "%!v:lua.MyTabLine()"
vim.opt.showtabline = 1
