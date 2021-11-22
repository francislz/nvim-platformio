local popup = require('plenary.popup')
local libraries = require('platformio-nvim.api.libraries')
local input = require('platformio-nvim.gui.input')

local function formatResults(items)
  local lines = {}
  for i = 1, #items do
    table.insert(lines, items[i].name)
    table.insert(lines, items[i].description)
    table.insert(lines, '')
  end
  return lines
end

local function test()
  local width = 120
  local height = 40
  local borderchars =  { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }
  local search_results = vim.api.nvim_create_buf(false, false)
  local win_id1 = popup.create(search_results, {
    title = "PlatformIO NVIM",
    highlight = "PlatformIO",
    relative = "editor",
    line = math.floor(((vim.o.lines - height) / 2) - 1),
    col = math.floor((vim.o.columns - width) / 2),
    minwidth = width,
    minheight = height,
    borderchars = borderchars,
  })
  local search = input:new({
    line = math.floor(((vim.o.lines - height) / 2) + height + 1),
    col = math.floor((vim.o.columns - width) / 2),
    width = width,
    is_prompt = true,
    callback = function (text)
      local results = libraries.search(text)
      vim.api.nvim_buf_set_lines(search_results, 0, 1, false, formatResults(results.items))
    end
  })
  search:display()
end

return {
  test = test
}
