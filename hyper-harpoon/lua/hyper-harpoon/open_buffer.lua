local M           = {};

local ui_utils    = require('hyper-harpoon.ui_utils')
local HyperHapoon = require("hyper-harpoon");

function M.open_hyperharpoon(tab_names, current_tab_name)
  local current_buf = vim.api.nvim_get_current_buf()
  -- 1. Create a new scratch buffer
  local buf = vim.api.nvim_create_buf(false, true) -- non-listed, scratch buffer

  -- 2. Calculate dimensions (60% of the editor's width/height)
  local width = math.floor(vim.o.columns * 0.6)
  local base_height = math.floor(vim.o.lines * 0.6)
  local tab_bar_height = 1                            -- Height for the tab bar (1 line)
  local content_height = base_height - tab_bar_height -- Height for content below tabs
  local title = " Tab:" .. current_tab_name .. " ";


  -- 3. Position the floating window at the top center
  local opts = {
    relative = 'editor',                               -- Position relative to the entire editor
    width = width,
    height = base_height,                              -- Total height including tabs
    row = math.floor((vim.o.lines - base_height) / 2), -- Top of the editor (1-based indexing)
    col = math.floor((vim.o.columns - width) / 2),     -- Center horizontally
    style = 'minimal',                                 -- Hide window decorations
    border = 'rounded',                                -- Add a rounded border (optional)
  }

  local total_padding = width - #title
  local left_padding = math.max(0, math.floor(total_padding / 2))
  local right_padding = math.max(0, total_padding - left_padding)

  opts.title = string.rep("─", left_padding) .. title .. string.rep("─", right_padding)


  -- 4. Create the floating window and attach the buffer
  local win = vim.api.nvim_open_win(buf, true, opts) -- 'true' to enter the window

  -- 5. Draw tab structure at the top
  local selected_tab_index = 1 -- Default to first tab selected for now
  if current_tab_name then
    for i, tab_name in ipairs(tab_names) do
      if tab_name == current_tab_name then
        selected_tab_index = i
        break
      end
    end
  end

  -- ui_utils.draw_tab_structure(buf, HyperHapoon.tabs, selected_tab_index);


  -- 6. Load saved lines and set them in the buffer (starting after tab line)
  local saved_lines = require("hyper-harpoon.load_lines").load_lines();
  -- Add an empty line after the tabs to separate content
  -- local lines_to_set = vim.list_extend({ "" }, saved_lines)   -- Add empty line at the beginning

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, saved_lines) -- Set lines, tab line is at the beginning now


  -- 7. Position cursor below the tab line (on the content area)
  -- vim.api.nvim_win_set_cursor(win, { tab_bar_height + 1, 0 }) -- +1 to move cursor to the line *below* the tab line


  -- 8. Optional: Set keymaps to close the window
  vim.keymap.set('n', 'q', function()
    vim.api.nvim_win_close(win, true) -- Close the window and hide the buffer
  end, { buffer = buf })

  -- listen for enter key and get line
  local key_commands = require("hyper-harpoon.listen_for_key_commands");
  key_commands.listen_for_enter(nil, buf);
  key_commands.listen_for_escape(nil, buf);
  key_commands.listen_for_buffer_change(buf);
  key_commands.listen_for_tab_key(buf); -- You might need to adapt listen_for_tab_key to handle tab switching logic
  key_commands.listen_for_tab_change(buf);
  return buf;
end

return M;
