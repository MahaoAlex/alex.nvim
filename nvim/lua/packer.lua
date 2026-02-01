local ok, packer = pcall(require, 'packer')
if not ok then
  return
end

packer.startup({
  function(use)
    -- Your plugin list...
    -- use 'neovim/nvim-lspconfig'
    -- ...
  end,
  config = {
    max_jobs = 2, -- Keep concurrency low to avoid network congestion
    clone_timeout = 600, -- Extend timeout to 10 minutes
  },
})
