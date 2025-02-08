local M = {};

function M.open_hyperharpoon()
  local current_buf = vim.api.nvim_get_current_buf()
  -- 1. Create a new scratch buffer
  local buf = vim.api.nvim_create_buf(false, true) -- non-listed, scratch buffer

  -- 2. Calculate dimensions (60% of the editor's width/height)
  local width = math.floor(vim.o.columns * 0.6)
  local height = math.floor(vim.o.lines * 0.6)
  local title = " Hyper Harpoon "


  -- 3. Position the floating window at the top center
  local opts = {
    relative = 'editor', -- Position relative to the entire editor
    width = width,
    height = height,
    title = title,
    row = math.floor((vim.o.lines - height) / 2),  -- Top of the editor (1-based indexing)
    col = math.floor((vim.o.columns - width) / 2), -- Center horizontally
    style = 'minimal',                             -- Hide window decorations
    border = 'rounded',                            -- Add a rounded border (optional)
  }

  local total_padding = width - #title
  local left_padding = math.max(0, math.floor(total_padding / 2))
  local right_padding = math.max(0, total_padding - left_padding)

  opts.title = string.rep("─", left_padding) .. title .. string.rep("─", right_padding)


  -- 4. Create the floating window and attach the buffer
  local win = vim.api.nvim_open_win(buf, true, opts) -- 'true' to enter the window

  -- 5. Optional: Add text to the buffer
  -- vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "Hello from Hyper Harpoon!" })

  -- 6. Optional: Set keymaps to close the window
  vim.keymap.set('n', 'q', function()
    vim.api.nvim_win_close(win, true) -- Close the window and hide the buffer
  end, { buffer = buf })

  -- Load saved lines and set them in the buffer
  local saved_lines = require("hyper-harpoon.load_lines").load_lines();
  -- print("Saved lines: " .. saved_lines);
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, saved_lines)

  -- listen for enter key and get line
  require("hyper-harpoon.listen_for_key_commands").listen_for_enter(nil, buf);
  require("hyper-harpoon.listen_for_key_commands").listen_for_escape(nil, buf);
  require("hyper-harpoon.listen_for_key_commands").listen_for_buffer_change(buf);
  require("hyper-harpoon.listen_for_key_commands").listen_for_tab_key(buf);
  return buf;
end

return M;
