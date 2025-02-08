local M = {};

local hyperHarpoon = require("hyper-harpoon");

function M.listen_for_enter(win, buf)
  -- local save_line = require("hyper-harpoon.save_lines").save_lines;
  -- Set keymap for the buffer inside the window
  vim.keymap.set("n", "<CR>", function()
    local line = vim.api.nvim_get_current_line();
    print("Enter pressed on: " .. line);
    require("hyper-harpoon.open_file").load_or_create_buffer_in_same_tab(line);
  end, { buffer = buf }) -- Make sure to bind it to the current buffer
end

function M.listen_for_escape(win, buf)
  vim.keymap.set("i", "<Esc>", function()
    local buffer_lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false); -- 0 to -1 means from the first to the last line
    -- Join the lines together into a single string (optional, depending on your needs)
    local lines = table.concat(buffer_lines, "\n")
    require("hyper-harpoon.save_lines").save_lines({ lines });
    print(line);

    -- Exit insert mode and return to normal mode
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
  end, { buffer = buf });
end;

function M.listen_for_buffer_change(buf)
  -- Create an autocmd to listen for changes in the buffer
  vim.api.nvim_create_autocmd("TextChanged", {
    buffer = buf,
    callback = function()
      -- Get the lines from the buffer
      local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

      -- Save the lines to a file
      require("hyper-harpoon.save_lines").save_lines(lines)
    end,
  })
end

function M.listen_for_tab_key(buf)
  vim.keymap.set("n", "<C-a>", function()
    local tabs = hyperHarpoon.tabs;
    if (tabs ~= nil) then
      for _, tab in ipairs(tabs) do
        print(" - " .. tab);
      end;
    else
      print("Error in listen_for_tab_key");
    end;
  end, { buffer = buf }) -- Make sure to bind it to the current buffer
end

return M;
