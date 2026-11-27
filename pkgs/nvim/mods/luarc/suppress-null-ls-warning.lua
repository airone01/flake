-- Suppress null-ls deprecation warnings

local notify = vim.notify
vim.notify = function(msg, ...)
  if msg:match("null%-ls") then
    return
  end
  notify(msg, ...)
end
