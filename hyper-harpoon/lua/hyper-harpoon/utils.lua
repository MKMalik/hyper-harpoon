local M = {};

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

return M;
