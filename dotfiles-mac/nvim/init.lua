-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Basic sane defaults
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.termguicolors = true
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 250
vim.g.mapleader = " "

-- C/C++: use cindent (better than smartindent for nested braces)
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "c", "cpp", "h", "hpp" },
	callback = function()
		vim.bo.cindent = true
		vim.bo.smartindent = false
	end,
})

-- Keymaps
vim.keymap.set("n", "<leader>r", ":w<CR>:!.venv/bin/python %<CR>", { desc = "Save and run current Python file" })

-- Plugins
require("lazy").setup({
	-- Smooth window scrolling (Ctrl-d, Ctrl-u, zz, etc.)
	{
		"karb94/neoscroll.nvim",
		config = function()
			require("neoscroll").setup({
				mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "<C-y>", "<C-e>", "zt", "zz", "zb" },
				hide_cursor = false,
				stop_eof = true,
				respect_scrolloff = false,
				cursor_scrolls_alone = true,
				easing_function = "sine", -- options: "quadratic", "cubic", "quartic", "quintic", "circular", "sine"
			})
		end,
	},

	-- Theme
	{
		"yorumicolors/yorumi.nvim",
		priority = 1000, -- load before all other start plugins
		lazy = false,
		config = function()
			vim.cmd("colorscheme yorumi")
		end,
	},

	-- Treesitter: better syntax highlighting + indentation
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		build = ":TSUpdate",
		config = function()
			-- Swift (and other parsers with requires_generate_from_grammar) need
			-- `tree-sitter generate`. nvim-treesitter hardcodes a `--no-bindings`
			-- flag that newer tree-sitter-cli (0.27+, e.g. via Homebrew) rejects,
			-- which breaks the install with a big CLI usage error.
			require("nvim-treesitter.install").ts_generate_args = {
				"generate",
				"--abi",
				vim.treesitter.language_version,
			}

			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"c",
					"python",
					"lua",
					"vim",
					"vimdoc",
					"bash",
					"markdown",
					"typescript",
					"tsx",
					"swift",
				},
				auto_install = true,
				highlight = { enable = true },
				indent = { enable = true, disable = { "c", "cpp" } },
			})
		end,
	},

	-- Mason: installs LSP servers / formatters
	{ "williamboman/mason.nvim", config = true },
	{
		"williamboman/mason-lspconfig.nvim",
		opts = { ensure_installed = { "clangd", "pyright", "ruff", "ts_ls" } },
	},

	-- LSP config (uses the new vim.lsp.config API on nvim 0.11+)
	{
		"neovim/nvim-lspconfig",
		dependencies = { "hrsh7th/cmp-nvim-lsp" },
		config = function()
			local caps = require("cmp_nvim_lsp").default_capabilities()

			vim.lsp.config("*", { capabilities = caps })
			vim.lsp.enable({ "clangd", "pyright", "ruff", "ts_ls" })

			-- LSP keymaps (active when a server attaches to a buffer)
			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(ev)
					local opts = { buffer = ev.buf, silent = true }
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
					vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
					vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
					vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
					vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
				end,
			})

			vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
			vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
			vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Show diagnostic" })
		end,
	},

	-- Completion
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
		},
		config = function()
			local cmp = require("cmp")
			cmp.setup({
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					["<Tab>"] = cmp.mapping.select_next_item(),
					["<S-Tab>"] = cmp.mapping.select_prev_item(),
					["<C-Space>"] = cmp.mapping.complete(),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "path" },
					{ name = "buffer" },
				}),
			})
		end,
	},

	-- Autopairs: auto-close (), [], {}, "", '', etc.
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		dependencies = { "hrsh7th/nvim-cmp" },
		config = function()
			require("nvim-autopairs").setup({})
			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			local cmp = require("cmp")
			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
		end,
	},

	-- Fuzzy finder
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local t = require("telescope.builtin")
			vim.keymap.set("n", "<leader>sf", t.find_files, { desc = "Search files" })
			vim.keymap.set("n", "<leader>sg", t.live_grep, { desc = "Search by grep" })
			vim.keymap.set("n", "<leader>sb", t.buffers, { desc = "Search buffers" })
			vim.keymap.set("n", "<leader>sh", t.help_tags, { desc = "Search help" })
			vim.keymap.set("n", "<leader>sd", t.diagnostics, { desc = "Search diagnostics" })
		end,
	},

	-- Formatter (format-on-save)
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				python = { "ruff_format" },
				c = { "clang-format" },
				lua = { "stylua" },
				typescript = { "prettier" },
			},
			format_on_save = { timeout_ms = 1000, lsp_fallback = true },
		},
	},

	-- Git signs in the gutter
	{ "lewis6991/gitsigns.nvim", config = true },

	-- Status line
	{
		"nvim-lualine/lualine.nvim",
		opts = { options = { theme = "auto", section_separators = "", component_separators = "" } },
	},

	-- Surround: ys/cs/ds to wrap/change/delete surrounding chars
	{ "kylechui/nvim-surround", event = "VeryLazy", config = true },

	-- which-key: popup showing available keybinds after a prefix
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		config = function()
			require("which-key").setup({})
		end,
	},

	-- File tree sidebar (VSCode-style)
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
		config = function()
			require("neo-tree").setup({
				filesystem = {
					follow_current_file = { enabled = true },
					hijack_netrw_behavior = "open_default",
				},
			})
			vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle<cr>", { desc = "Toggle file tree" })
		end,
	},

	-- Highlight TODO / FIXME / HACK / NOTE comments
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		event = "VeryLazy",
		config = function()
			require("todo-comments").setup({})
			vim.keymap.set("n", "<leader>st", "<cmd>TodoTelescope<cr>", { desc = "Search TODOs" })
		end,
	},

	-- Vertical indent guides
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = {},
	},
})
