local M = {};

M.floating_buffer = nil;
M.data_file_dir = nil;
M.data_file_name = nil;
M.current_tab = "1";
M.tabs = { "1", "2", "3" };

M.setup = function()
  require("hyper-harpoon.setup").setup();
end;

M.say_hello = function()
  require("hyper-harpoon.say_hello").say_hello();
end;

M.open_hyperharpoon = function()
  M.floating_buffer = require("hyper-harpoon.open_buffer").open_hyperharpoon();
end;

M.add_path = function()
  local current_buf = vim.api.nvim_get_current_buf()
  require("hyper-harpoon.add_path").add_relative_path(current_buf);
end

return M;
