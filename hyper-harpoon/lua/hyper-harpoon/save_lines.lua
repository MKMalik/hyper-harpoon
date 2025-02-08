local M = {};

function M.save_lines(lines, file_mode)
  local data_file_dir = require("hyper-harpoon").data_file_dir;
  local data_file_name = require("hyper-harpoon").data_file_name -- Just the filename part
  local current_tab = require("hyper-harpoon").current_tab;
  local base_data_dir = vim.fn.stdpath('data') .. data_file_dir .. "/" .. current_tab;
  local filepath = base_data_dir .. "/" .. data_file_name;
  -- Debug print statements - ADD THESE:
  print("base_data_dir:", base_data_dir)


  -- Ensure the directory exists. Create parent directories if necessary.
  local ok, err = pcall(vim.fn.mkdir, base_data_dir, "p") -- 'p' flag for parent directories
  if not ok then
    print("Error creating directory: " .. base_data_dir .. " - " .. err)
    return -- Exit if directory creation failed
  end

  -- Determine file mode if not provided
  if file_mode == nil then
    if vim.fn.filereadable(filepath) == 1 then
      file_mode = "w"
    else
      file_mode = "w"
    end
  end

  local file = io.open(filepath, file_mode) -- Open the file with determined file_mode
  if file then
    for _, line in ipairs(lines) do
      file:write(line .. "\n") -- Write each line followed by a newline
    end
    file:close()
  else
    print("Error saving lines to file: " .. filepath)
  end
end;

return M;
