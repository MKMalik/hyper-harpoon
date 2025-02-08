local M = {};

function M.add_relative_path(buf)
  -- Get the full path of the current buffer
  local full_path = vim.api.nvim_buf_get_name(buf)

  -- Get the current working directory
  local cwd = vim.fn.getcwd()

  -- Remove the cwd part from the full path to get the relative path
  local relative_path = string.sub(full_path, #cwd + 2)

  print("Current path: " .. relative_path);

  require("hyper-harpoon.save_lines").save_lines({ relative_path }, "a")

  return relative_path
end;

return M;
