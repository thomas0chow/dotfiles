require("plugins")
require("settings")
require("maps")

-- Formatter
-- vim.cmd [[autocmd BufWrite *.py call CocAction('format')]]
vim.cmd [[autocmd BufWritePre * :call CocAction('runCommand', 'editor.action.organizeImport')]]

-- Language
vim.cmd("language en_US")
