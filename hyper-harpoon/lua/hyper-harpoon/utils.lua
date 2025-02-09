local M = {};
local HyperHarpoon = require("hyper-harpoon");

function M.get_dir_opened_as_key()
  local current_dir = vim.fn.getcwd()
  local dir_opened_as_key = string.gsub(current_dir, "/", "_")
  return dir_opened_as_key
end

function M.resolve_data_file_path(dir_key, current_tab)
  local data_file_path = "/hyper-harpoon/" .. dir_key .. "/data_file.txt"
  return data_file_path;
end

function M.list_directories_in_dir(dir_path)
  local list = {}
  local handle = io.popen("ls -a " .. vim.fn.escape(dir_path, " ")) -- Use ls -a and escape path

  if handle then
    for filename in handle:lines() do
      table.insert(list, filename)
    end
    handle:close()
    return list
  else
    return nil, "Error: Could not read directory: " .. dir_path
  end
end

-- create new tab
function M.create_new_tab(base_dir, tab_name)
  -- Construct the full path for the tab directory
  local tab_dir_path = base_dir .. "/" .. tab_name

  -- Check if the base directory exists, and create it if not
  local ok_tab_dir, err_tab_dir = pcall(vim.fn.mkdir, tab_dir_path, "p")
  if not ok_tab_dir then
    return nil, "Error creating base directory: " .. base_dir .. " - " .. err_base_dir
  end


  -- insert tab into table
  table.insert(HyperHarpoon.tabs, ok_tab_dir);
  -- If everything is successful, return the path to the tab directory
  return tab_dir_path, nil
end

function M.count_tabs(base_dir)
  -- Check if the base directory exists and is a directory
  if not vim.fn.isdirectory(base_dir) then
    return 0, "Error: Base directory does not exist or is not a directory: " .. base_dir
  end

  local entries, error_msg = M.list_directories_in_dir(base_dir) -- Reuse the directory listing function

  if not entries then
    return 0, error_msg -- Return error from list_directories_in_dir if it failed
  end

  local tab_dir_count = 0
  for _, entry_name in ipairs(entries) do
    -- Construct full path to check if it's a directory.
    -- Need to handle "." and ".." entries which are always listed by "ls -a"
    if entry_name ~= "." and entry_name ~= ".." then
      local entry_path = base_dir .. "/" .. entry_name
      if vim.fn.isdirectory(entry_path) == 1 then
        tab_dir_count = tab_dir_count + 1
      end
    end
  end
  return tab_dir_count, nil
end

function M.get_user_string_input(prompt_message)
  -- Use vim.fn.input() to prompt the user for input
  local user_input = vim.fn.input(prompt_message .. ": ") -- Add a colon and space to the prompt for better readability

  -- Check if the user cancelled input (by pressing <Esc> or <C-c>)
  if user_input == nil then
    return nil, "Input cancelled by user." -- Return nil and an error message if cancelled
  end

  -- Return the user's input string
  return user_input, nil -- Return the input string and nil for error (success)
end

function M.ensure_directory_exists(dir_path)
  -- Check if the directory already exists
  if not vim.fn.isdirectory(dir_path) then
    -- Directory does not exist, attempt to create it (and parent directories)
    local ok, err = pcall(vim.fn.mkdir, dir_path, "p") -- 'p' flag for parent directories
    if not ok then
      -- Directory creation failed
      return false, "Error creating directory: " .. dir_path .. " - " .. err
    end
    -- Directory creation successful
    return true, nil
  else
    -- Directory already exists
    return true, nil
  end
end

function M.change_tab(tabs, current_tab, buf)
  local current_tab_index = nil
  print("Tab change: " .. current_tab);

  -- 1. Find the index of the current tab
  for index, tab_name in ipairs(tabs) do
    if tab_name == current_tab then
      current_tab_index = index
      break
    end
  end

  -- Handle case where current_tab is not found (though it should be in a valid scenario)
  if not current_tab_index then
    print("Warning: Current tab not found in tabs list: " .. current_tab)
    return 1 -- Or you might want to return the first tab, or handle it differently
  end

  -- 2. Calculate the index of the next tab (circular fashion)
  local next_tab_index = current_tab_index + 1
  local num_tabs = #tabs

  if next_tab_index > num_tabs then
    next_tab_index = 1 -- Wrap around to the first tab if at the end
  end

  -- 3. Get the name of the next tab
  local next_tab_name = tabs[next_tab_index]

  HyperHarpoon.current_tab = next_tab_name;
  -- close this buffer and reopen new
  local current_win = vim.api.nvim_get_current_win()
  if current_win then
    local force_close = true -- Set to false if you want to prevent closing with unsaved changes on unsaved buffer
    local ok, err = pcall(vim.api.nvim_win_close, current_win, force_close)
    if not ok then
      print("Error closing window: " .. err)
      -- Handle error if needed
    end
  else
    print("No current window found to close.")
    -- Handle case where there's no current window (unlikely in normal Neovim usage)
  end

  -- reopen to reload new data of tab change
  HyperHarpoon.open_hyperharpoon();

  -- Return the name of the next tab
  return next_tab_name
end

return M;
