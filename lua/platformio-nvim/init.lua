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
    }),
    windows = {}
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

  -- local details_window = window:new(picker.layout_strategy.details)
  -- details_window:display()

  local search = input:new(picker.layout_strategy.prompt)
  vim.fn.prompt_setcallback(search.buffer, function (text)
    print(text)
    local results = libraries.search(text)
    vim.api.nvim_buf_set_lines(result_window.buffer, 0, 1, false, formatResults(results.items))
  end)
  search:display()
  local key_func = function ()
    print('test')
  end
  print(type(key_func))
  vim.api.nvim_buf_set_keymap(search.buffer, 'n', '<esc>', [[:lua print(math.random())<CR>]], { noremap = true })
end

--[[__TelescopeKeymapStore = setmetatable({}, {
    1   __index = function(t, k)
    2   rawset(t, k, {})
    3   print(dump(t), k)
    4   return rawget(t, k)
    5   end,
    6 })
    7 local keymap_store = __TelescopeKeymapStore
    8  
    9 local _mapping_key_id = 0
   10 local get_next_id = function()
   11   _mapping_key_id = _mapping_key_id + 1
   12   return _mapping_key_id
   13 end
   14  
   15 local assign_function = function(prompt_bufnr, func)
   16   local func_id = get_next_id()
   17  
   18   keymap_store[prompt_bufnr][func_id] = func
   19  
   20   return func_id
   21 end
   ]]--

return {
  test = test
}
