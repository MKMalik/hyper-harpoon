local M = {}

local HyperHarpoon = require("hyper-harpoon");
local utils = require("hyper-harpoon.utils");
local get_user_string_input = utils.get_user_string_input;
local create_new_tab = utils.create_new_tab;

function M.create_new_tab_ui()
  local tab_name = get_user_string_input("Enter tab name");
  if tab_name == nil then
    tab_name = HyperHarpoon.default_tab_name;
  end;
  local ok, err = create_new_tab(HyperHarpoon.data_file_dir, tab_name);
end;

function M.draw_tab_structure(bufnr, tab_names, selected_tab_index)
  local lines = {}
  local tab_line = ""

  -- Define highlight groups (you can customize these in your colorscheme)
  local selected_hl = "TabSelected"
  local unselected_hl = "TabUnselected"

  -- Basic dynamic highlight group creation (for example purposes - better to define in colorscheme)
  vim.api.nvim_command('highlight default link TabSelected Title')     -- Example: Link to 'Title'
  vim.api.nvim_command('highlight default link TabUnselected Comment') -- Example: Link to 'Comment'

  for i, tab_name in ipairs(tab_names) do
    local tab_text = " " .. tab_name .. " "
    if i == selected_tab_index then
      tab_line = tab_line .. "[" .. tab_text .. "]" -- Selected tab style (brackets)
    else
      tab_line = tab_line .. "(" .. tab_text .. ")" -- Unselected tab style (parentheses)
    end
  end

  table.insert(lines, tab_line) -- Add the constructed tab line to the lines table

  -- Set the lines in the buffer (replace the first line)
  vim.api.nvim_buf_set_lines(bufnr, 0, 1, false, lines)

  -- Apply highlights to the tab names in the tab line
  local byte_start = 0
  for i, tab_name in ipairs(tab_names) do
    local tab_text = " " .. tab_name .. " "
    local tab_length = #tab_text
    local start_col = 0
    local end_col = 0

    if i == selected_tab_index then
      start_col = byte_start + 1                                                             -- +1 to skip '['
      end_col = start_col + tab_length +
      1                                                                                      -- +1 to include last char of tab_text and before ']'
      vim.api.nvim_buf_add_highlight(bufnr, 0, selected_hl, 0, start_col - 1, end_col - 1)   -- Apply selected highlight
      byte_start = byte_start + 2 +
      tab_length                                                                             -- Account for "[tab_text]" length (2 brackets + text)
    else
      start_col = byte_start + 1                                                             -- +1 to skip '('
      end_col = start_col + tab_length +
      1                                                                                      -- +1 to include last char of tab_text and before ')'
      vim.api.nvim_buf_add_highlight(bufnr, 0, unselected_hl, 0, start_col - 1, end_col - 1) -- Apply unselected highlight
      byte_start = byte_start + 2 +
      tab_length                                                                             -- Account for "(tab_text)" length (2 parentheses + text)
    end
  end
end

return M;
