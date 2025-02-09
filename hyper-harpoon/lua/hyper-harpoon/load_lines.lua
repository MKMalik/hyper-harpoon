local M = {};

function M.load_lines()
  local data_file_dir = require("hyper-harpoon").data_file_dir;
  local data_file_name = require("hyper-harpoon").data_file_name;                                          -- Corrected to use data_file_name
  local current_tab = require("hyper-harpoon").current_tab;
  local filepath =  data_file_dir .. "/" .. current_tab .. "/" .. data_file_name; -- Construct the full file path
  local lines = {}

  local file = io.open(filepath, "r") -- Open the file in read mode
  if file then
    for line in file:lines() do
      table.insert(lines, line) -- Add each line to the table
    end
    file:close()                -- Close the file
  else
    print("No saved lines found.")
  end
  return lines
end;

return M;
