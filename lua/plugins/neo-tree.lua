return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"nvim-tree/nvim-web-devicons",
		},
		lazy = false,

		keys = {
			{ "<leader>F", "<cmd>Neotree toggle<cr>", desc = "Neo-tree toggle" },
		},

		-- 2. Pass opts as an argument into the config function
		config = function(_, opts)
			-- Apply colors first
			vim.api.nvim_set_hl(0, "NeoTreeFileName", { fg = "#75715E" })
			vim.api.nvim_set_hl(0, "NeoTreeRootName", { fg = "#1E1F1C", bold = true })

			git_status = {
				window = {
					position = "float",
					mappings = {
						["S"]  = "git_add_all",
						["gu"] = "git_unstage_file",
						["ga"] = "git_add_file",
						["gr"] = "git_revert_file",
						["gc"] = "git_commit",
					}
				}
			}

			-- Manually initialize the plugin with your opts from below
			require("neo-tree").setup(opts)
		end,

		opts = {
			filesystem = {
				filtered_items = {
					visible = true,
					show_hidden_count = true,
					hide_dotfiles = false,
					hide_gitignored = true,
					hide_by_name = {},
					never_show = {},
				},
			}
		}
	}
}
