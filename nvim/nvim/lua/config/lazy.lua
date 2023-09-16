-- See https://github.com/folke/lazy.nvim

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local lazy_install_dir
if vim.env.LAZY_NVIM_INSTALL_DIR == nil then
  lazy_install_dir = vim.fn.stdpath("data") .. "/lazy"
else
  lazy_install_dir = vim.env.LAZY_NVIM_INSTALL_DIR
end

require('lazy').setup('plugins', {
  root = lazy_install_dir,
  change_detection = {
    enabled = true,
    notify = false,
  }
})
