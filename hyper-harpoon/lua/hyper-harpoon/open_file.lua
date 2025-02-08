local M = {};

function M.load_or_create_buffer_in_same_tab(relative_path)
  -- first close the hyper-harpoon buffer
  vim.api.nvim_buf_delete(require("hyper-harpoon").floating_buffer, { force = true });
  -- Normalize the relative path to be absolute or relative to current working directory if needed
  local filepath = vim.fn.expand(relative_path)

  -- Get list of all buffers
  local buffers = vim.api.nvim_list_bufs()

  -- Iterate through buffers to check if the file is already open
  for _, buf_nr in ipairs(buffers) do
    if vim.api.nvim_buf_is_valid(buf_nr) then                   -- Check if buffer is still valid
      local buf_name = vim.api.nvim_buf_get_name(buf_nr)
      if buf_name ~= "" then                                    -- Ensure it's a file buffer and not a scratch buffer without a name
        local buf_filepath = vim.fn.fnamemodify(buf_name, ":p") -- Get absolute path of buffer file
        if buf_filepath == filepath then
          -- File is already open, switch to that buffer
          vim.api.nvim_command("buffer " .. buf_nr)
          return -- Exit function as we are done
        end
      end
    end
  end

  -- File is not open, create a new buffer and load the file
  vim.cmd("edit " .. filepath)
end

return M;
