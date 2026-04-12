local function map(mode, lhs, rhs)
	vim.keymap.set(mode, lhs, rhs, { silent = true })
end

-- Diffview toggle (horizontal when wide, vertical when narrow)
local diffview_open = false

local function diffview_layout()
    return vim.o.columns >= 180 and "diff2_horizontal" or "diff2_vertical"
end

local function diffview_apply_config()
    require("diffview.config").get_config().view.default.layout = diffview_layout()
end

map("n", "\\dv", function()
    if diffview_open then
        vim.cmd("DiffviewClose")
        diffview_open = false
    else
        diffview_apply_config()
        vim.cmd("DiffviewOpen")
        diffview_open = true
    end
end)

-- Auto-switch layout and file panel on terminal resize
vim.api.nvim_create_autocmd("VimResized", {
    callback = function()
        if not diffview_open then return end
        diffview_apply_config()
        vim.cmd("DiffviewClose")
        vim.cmd("DiffviewOpen")
    end,
})

-- Telescope
map("n", "<leader>ff", function() require("telescope.builtin").find_files() end)
map("n", "<leader>fg", function() require("telescope.builtin").live_grep() end)
map("n", "<leader>fb", function() require("telescope.builtin").buffers() end)
map("n", "<leader>fh", function() require("telescope.builtin").help_tags() end)
map("n", "<leader>fs", function() require("telescope.builtin").git_status() end)
map("n", "<leader>fc", function() require("telescope.builtin").git_commits() end)


