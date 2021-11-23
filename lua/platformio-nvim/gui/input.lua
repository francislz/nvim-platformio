local popup = require('plenary.popup')

local Input = {}

function Input:new(opts)
  opts = opts or {}
  local object = setmetatable({
    win_id = '',
    callback = opts.callback,
    buffer = vim.api.nvim_create_buf(false, false),
    line = opts.line,
    col = opts.col,
    width = opts.width,
  }, self)
  self.__index = self

  if opts.is_prompt then
    vim.api.nvim_buf_set_option(object.buffer, "buftype", "prompt")
    vim.fn.prompt_setprompt(object.buffer, 'search> ')
  end
  return object
end

function Input:set_callback(callback)
  self.callback = callback
  if self.is_prompt then
    vim.fn.prompt_setcallback(self.buffer, callback)
  end
end

function Input:set_buffer_type(buftype)
  vim.api.nvim_buf_set_option(self.buffer, "buftype", buftype)
end

function Input:display()
  self.win_id = popup.create(self.buffer, {
    relative = "editor",
    line = self.line,
    col = self.col,
    minwidth = self.width,
    minheight = 1,
    borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
  })
end

return Input
