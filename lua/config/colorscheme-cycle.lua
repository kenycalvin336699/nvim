local state_file = vim.fn.stdpath("data") .. "/colorscheme_cycle.txt"

local schemes = {
  "catppuccin", "catppuccin-frappe", "catppuccin-macchiato", "catppuccin-mocha",
  "tokyonight", "tokyonight-moon", "tokyonight-night", "tokyonight-storm",
  "kanagawa", "kanagawa-wave", "kanagawa-dragon",
  "nightfox", "duskfox", "nordfox", "terafox", "carbonfox",
}

-- keep only schemes that are actually installed (avoids startup errors)
local installed = {}
for _, name in ipairs(vim.fn.getcompletion("", "color")) do
  installed[name] = true
end
schemes = vim.tbl_filter(function(n) return installed[n] end, schemes)
if #schemes == 0 then return end

math.randomseed(os.time())

local function read_last()
  local f = io.open(state_file, "r")
  if not f then return nil end
  local name = f:read("*l")
  f:close()
  return name
end

local function write_last(name)
  local f = io.open(state_file, "w")
  if f then f:write(name) f:close() end
end

local last = read_last()
local choice = schemes[math.random(#schemes)]
while #schemes > 1 and choice == last do
  choice = schemes[math.random(#schemes)]
end

if pcall(vim.cmd.colorscheme, choice) then
  write_last(choice)
end
