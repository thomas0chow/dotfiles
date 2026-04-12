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

local status, telescope = pcall(require, "telescope.builtin")
if status then
	-- Telescope
	map("n", "<leader>ff", telescope.find_files)
	map("n", "<leader>fg", telescope.live_grep)
	map("n", "<leader>fb", telescope.buffers)
	map("n", "<leader>fh", telescope.help_tags)
	map("n", "<leader>fs", telescope.git_status)
	map("n", "<leader>fc", telescope.git_commits)
else
	print("Telescope not found")
end


