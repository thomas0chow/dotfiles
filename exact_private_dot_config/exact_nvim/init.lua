require("settings")
require("maps")
require("plugins")

-- Color scheme
local themeStatus = pcall(require, "nord")

if themeStatus then
    vim.cmd("colorscheme nord")
else
    return
end

-- Formatter
vim.cmd [[autocmd BufWritePre * undojoin | Autoformat]]
