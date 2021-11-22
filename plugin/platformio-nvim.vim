fun! PlatformioNvim()
  lua for k in pairs(package.loaded) do if k:match("^platformio%-nvim") then package.loaded[k] = nil end end
  lua require("platformio-nvim").test()
endfun

augroup PlatformioNvim
  autocmd!
augroup END
