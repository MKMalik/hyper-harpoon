local Setup = {}

function Setup.setup()
  local M = require("hyper-harpoon")
  -- define data_file location and name
  -- /hyper-harpoon/${dir_opened_as_key}/data_file.txt
  local dir_key = require("hyper-harpoon.utils").get_dir_opened_as_key();
  local data_file_path = "/hyper-harpoon/" .. dir_key
  M.data_file_dir = data_file_path;
  M.data_file_name = "/data_file.txt"

  -- tabs
  -- check if more tabs available (dir)

  local tabs, error_message = require("hyper-harpoon.utils").list_directories_in_dir(M.data_file_dir);
  if (tabs ~= nil) then
    for _, tab in ipairs(tabs) do
      print(" - " .. tab);
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
