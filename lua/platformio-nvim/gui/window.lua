local popup = require('plenary.popup')

local Window = {}

function Window:new(opts)
  opts = opts or {}

  local object = setmetatable({
    title = opts.title,
    highlight = opts.highlight,
    relative = opts.relative or 'editor',
    line = opts.line,
    col = opts.col,
    width = opts.width,
    height = opts.height,
    borderchars = opts.borderchars or { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    win_id = '',
    buffer = vim.api.nvim_create_buf(false, false),
  }, self)
  self.__index = self

  return object
end

function Window:display()
  self.win_id = popup.create(self.buffer, {
    title = self.title,
    highlight = self.highlight,
    relative = self.relative,
    line = self.line,
    col = self.col,
    minwidth = self.width,
    minheight = self.height,
    borderchars = self.borderchars,
  })
end

return Window
