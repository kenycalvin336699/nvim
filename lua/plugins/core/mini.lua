return {
	"echasnovski/mini.nvim",
	version = false,                 -- mini recommends tracking latest, not pinned releases
	config = function()
		require("mini.pairs").setup() -- auto-close (), [], "", etc.
		require("mini.surround").setup() -- add/change/delete surrounding pairs
		require("mini.comment").setup() -- toggle comments
	end,
}
