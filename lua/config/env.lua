-- Detects the platform and which optional features are on, so every plugin
-- file can degrade quietly instead of erroring on machines that lack something.
local M = {}

function M.has(bin)
  return vim.fn.executable(bin) == 1
end

-- Termux (Android): bionic libc, so most downloaded prebuilt binaries won't run
M.is_termux = vim.env.TERMUX_VERSION ~= nil
  or (vim.env.PREFIX or ""):find("com.termux", 1, true) ~= nil

-- Mason needs these tools, and its downloaded binaries only run on glibc/musl Linux, macOS, Windows
M.use_mason = not M.is_termux
  and M.has("git")
  and (M.has("curl") or M.has("wget"))
  and M.has("unzip")
  and M.has("tar")
  and M.has("gzip")

-- Optional feature flags, off by default so a fresh install works anywhere.
-- Turn on in lua/config/local.lua (vim.g.enable_jupyter = true) or with an
-- environment variable (NVIM_JUPYTER=1).
function M.optional(name)
  return vim.g["enable_" .. name] == true or vim.env["NVIM_" .. name:upper()] == "1"
end

return M
