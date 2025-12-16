local telescope_ok, telescope = pcall(require, 'telescope')
if not telescope_ok then
  vim.notify('telescope not found', vim.log.levels.WARN)
  return
end

telescope.setup({
  defaults = {
    buffer_previewer_maker = function(filepath, bufnr, opts)
      opts = opts or {}
      vim.loop.fs_open(filepath, "r", 438, function(err, fd)
        if err then return end
        vim.loop.fs_fstat(fd, function(err, stat)
          if err then return end
          if stat.size > 100000 then

            vim.schedule(function()
              vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {"File too large to preview"})
            end)
          else
            vim.loop.fs_read(fd, stat.size, 0, function(err, data)
              if err then return end
              vim.schedule(function()
                if pcall(vim.api.nvim_buf_set_lines, bufnr, 0, -1, false, vim.split(data, "\n")) then
                  pcall(vim.api.nvim_buf_call, bufnr, function()
                    vim.cmd("filetype detect")
                  end)
                end
              end)
            end)
          end
          vim.loop.fs_close(fd)
        end)
      end)
    end,
  },
})

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>ps', builtin.live_grep, {})
