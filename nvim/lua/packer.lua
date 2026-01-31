local ok, packer = pcall(require, 'packer')
if not ok then
  return
end

packer.startup({
  function(use)
    -- 你的插件列表...
    -- use 'neovim/nvim-lspconfig'
    -- ...
  end,
  config = {
    max_jobs = 2, -- 把并发数降到最低，避免网络拥堵
    clone_timeout = 600, -- 延长超时时间到 10 分钟
  },
})
