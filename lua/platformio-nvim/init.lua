local curl = require('plenary.curl')
local popup = require('plenary.popup')

local function searchLib(query)
  local response = curl.get('https://api.registry.platformio.org/v2/lib/search?page=1&query=MQTT')
  return vim.fn.json_decode(response.body)
end

local function test()
  local width = 60
  local height = 10
  local borderchars =  { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }
  local win_id = popup.create({
    'test',
    'test 2',
    'test 3'
  }, {
    title = "PlatformIO NVIM",
    highlight = "PlatformIO",
    relative = "editor",
    line = math.floor(((vim.o.lines - height) / 2) - 1),
    col = math.floor((vim.o.columns - width) / 2),
    minwidth = width,
    minheight = height,
    borderchars = borderchars,
  })
  local win_id = popup.create({
  }, {
    relative = "editor",
    line = (((vim.o.lines - (2 * height) + 1) / 2) - 1),
    col = math.floor((vim.o.columns - width) / 2),
    minwidth = width,
    minheight = 1,
    borderchars = borderchars,
  })
end

return {
  test = test
}
