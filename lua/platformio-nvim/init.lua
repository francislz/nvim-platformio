local popup = require('plenary.popup')
local libraries = require('platformio-nvim.api.libraries')
local input = require('platformio-nvim.gui.input')
local window = require('platformio-nvim.gui.window')

local BaseLayoutStrategy = {
  prompt = {},
  results = {},
  details = {},
}

function BaseLayoutStrategy:new(o)
  o = o or {}
  local obj = setmetatable({
    prompt = {
      line = math.floor(((vim.o.lines - o.height) / 2) + o.height + 1),
      col = math.floor((vim.o.columns - o.width) / 2),
      width = o.width,
      is_prompt = true,
    },
    results = {
      title = "Libraries",
      highlight = "none",
      width = math.floor(o.width / 2),
      height = o.height - 1,
      line = math.floor(((vim.o.lines - o.height) / 2) - 1),
      col = math.floor((vim.o.columns - (o.width + 2)) / 2),
    },
    details = {
      title = "Details",
      highlight = "none",
      width = math.floor(o.width / 2),
      height = o.height - 1,
      line = math.floor(((vim.o.lines - o.height) / 2) - 1),
      col = math.floor((vim.o.columns - (o.width + 2)) / 2) + math.floor(o.width / 2) + 2
    },
  }, self)
  self.__index = self
  return obj
end

local Picker = {}

function Picker:new(opts)
  opts = opts or {
    width_factor = 0.44,
    height_factor = 0.65,
  }

  local object = setmetatable({
    width_factor = opts.width_factor or 0.44,
    height_factor = opts.height_factor or 0.65,
    layout_strategy = opts.layout_strategy or BaseLayoutStrategy:new({
      width = math.floor(vim.o.columns * opts.width_factor),
      height = math.floor(vim.o.lines * opts.height_factor),
    })
  }, self)
  return object
end

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
  local picker = Picker:new({ width_factor = 0.6, height_factor = 0.65 })

  local result_window = window:new(picker.layout_strategy.results)
  result_window:display()
  local details_window = window:new(picker.layout_strategy.details)
  details_window:display()
  local search = input:new(picker.layout_strategy.prompt)
  vim.fn.prompt_setcallback(search.buffer, function (text)
    print(text)
    local results = libraries.search(text)
    vim.api.nvim_buf_set_lines(result_window.buffer, 0, 1, false, formatResults(results.items))
  end)
  search:display()
end

return {
  test = test
}
