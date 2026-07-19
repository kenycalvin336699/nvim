local state_file = vim.fn.stdpath("data") .. "/colorscheme_cycle.txt"

-- flat list of every variant across your 4 plugins
local schemes = {
	"catppuccin-frappe",
	"catppuccin-macchiato",
	"catppuccin-mocha",
	"catppuccin",
	"catppuccin-nvim",
	"tokyonight-moon",
	"tokyonight",
	"tokyonight-night",
	"tokyonight-storm",
	"kanagawa-wave",
	"kanagawa-dragon",
	"kanagawa",
	"nightfox",
	"duskfox",
	"nordfox",
	"terafox",
	"carbonfox",
}


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
	if f then
		f:write(name)
		f:close()
	end
end

local last = read_last()
local choice = schemes[math.random(#schemes)]

-- avoid picking the same one twice in a row
if last and choice == last and #schemes > 1 then
	repeat
		choice = schemes[math.random(#schemes)]
	until choice ~= last
end

vim.cmd.colorscheme(choice)
write_last(choice)
