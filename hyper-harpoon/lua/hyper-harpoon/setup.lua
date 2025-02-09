local Setup = {}

function Setup.setup()
  local M = require("hyper-harpoon")
  -- define data_file location and name
  -- /hyper-harpoon/${dir_opened_as_key}/data_file.txt
  local utils = require("hyper-harpoon.utils");
  local dir_key = utils.get_dir_opened_as_key();
  local data_file_path = "/hyper-harpoon/" .. dir_key
  M.data_file_dir = vim.fn.stdpath('data') .. data_file_path;
  M.data_file_name = "/data_file.txt"

  -- check if base dir not exists
  utils.ensure_directory_exists(M.data_file_dir .. "/" .. M.default_tab_name .. "/");

  -- tabs
  -- check if more tabs available (dir)
  local number_of_tabs = utils.count_tabs(M.data_file_dir);
  if number_of_tabs < 1 then
    local default_tab_name = M.default_tab_name;
    utils.create_new_tab(M.data_file_dir, default_tab_name);
    table.insert(M.tabs, default_tab_name);
  end;

  M.current_tab = M.default_tab_name;

  local tabs, error_message = utils.list_directories_in_dir(M.data_file_dir);
  if (tabs ~= nil) then
    for _, tab in ipairs(tabs) do
      table.insert(M.tabs, tab);
    end;
  else
    print(error_message);
  end;
  -- Define keymaps
  vim.keymap.set("n", "<leader>hH", M.open_hyperharpoon, { desc = "Open Hyper Harpoon Window" })
  vim.keymap.set("n", "<leader>hm", M.say_hello, { desc = "Say Hello" })
  vim.keymap.set("n", "<leader>hA", M.add_path, { desc = "Add path to Hyper Harpoon" });
end

return Setup
