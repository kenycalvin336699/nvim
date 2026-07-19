return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		lazy = false,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"nvim-tree/nvim-web-devicons",
		},

		keys = {
			{ "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Neo-tree toggle" },
		},

		init = function()
			vim.api.nvim_set_hl(0, "NeoTreeDirectoryIcon", { fg = "#94907D" })
		end,

		opts = {
			enable_git_status = true,
			highlight_git_status = true,

			window = {
				width = 30,
				position = "left",
				mappings = {
					["S"]  = "git_add_all",
					["gu"] = "git_unstage_file",
					["ga"] = "git_add_file",
					["gr"] = "git_revert_file",
					["gc"] = "git_commit",
				},
			},

			filesystem = {
				follow_current_file = { enabled = true },
				use_libuv_file_watcher = true,
				filtered_items = {
					visible = true,
					hide_dotfiles = false,
					hide_gitignored = true,
				},
			},

			default_component_mixins = { git_status = true },
			default_column_definitions = {
				git_status = {
					symbols = {
						added     = "✚",
						modified  = "",
						deleted   = "✖",
						renamed   = "  ",
						untracked = "",
						ignored   = "",
						unstaged  = "  ",
						staged    = "",
						conflict  = "",

						-- ...
					},
				},
			},
		},

		config = function(_, opts)
			vim.api.nvim_set_hl(0, "NeoTreeFileName", { fg = "#94907D" })
			vim.api.nvim_set_hl(0, "NeoTreeRootName", { fg = "#75715E", bold = true })
			vim.api.nvim_set_hl(0, "NeoTreeDirectoryName", { fg = "#4E907D" })
			require("neo-tree").setup(opts) -- ✅ one setup call, no return
		end,
	},
}
