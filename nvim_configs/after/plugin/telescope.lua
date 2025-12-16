-- Setup telescope with proper configuration
local telescope_ok, telescope = pcall(require, 'telescope')
if not telescope_ok then
  vim.notify('telescope not found', vim.log.levels.WARN)
  return
end

-- Configure telescope
telescope.setup({
  defaults = {
    -- Use vim filetype detection instead of treesitter for previews
    -- This avoids the ft_to_lang deprecation issue
    file_previewer = require('telescope.previewers').vim_buffer_cat.new,
    grep_previewer = require('telescope.previewers').vim_buffer_vimgrep.new,
    qflist_previewer = require('telescope.previewers').vim_buffer_qflist.new,
  },
})

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>ps', builtin.live_grep, {})
