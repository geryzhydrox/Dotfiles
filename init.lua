require("rose-pine").setup({["disable_background"] = true,["disable_float_background"] = true})

-- Set up globals {{{
do
  local globals = {["mapleader"] = " "}

  for k,v in pairs(globals) do
    vim.g[k] = v
  end
end
-- }}}
-- Set up options {{{
do
  local options = {["clipboard"] = "unnamedplus", ["relativenumber"] = true, ["shiftwidth"] = 2, ["showmode"] = false, ["termguicolors"] = true}

  for k,v in pairs(options) do
    vim.opt[k] = v
  end
end

do
  local cmds = 
    {["I3config"] = {["command"] = ":e ~/.config/i3/config", ["options"] = {["desc"] = "Edit i3 config"}},
    ["Nixcfg"] = {["command"] = ":e /etc/nixos/configuration.nix", ["options"] = {["desc"] = "Edit Nixos config"}},
    ["Nt"] = {["command"] = ":NvimTreeToggle", ["options"] = {["desc"] = "Toggle NvimTree"}},
    ["Ntf"] = {["command"] = ":NvimTreeFocus", ["options"] = {["desc"] = "Focus NvimTree"}},
    ["Pmd"] = {["command"] = ':!pandoc -f commonmark_x -t pdf --pdf-engine=xelatex -V mainfont:FreeSans \"%\" -o /tmp/\"%:t:r\"', ["options"] = {["desc"] = "Compile current markdown file to pdf in /tmp"}},
    ["Pzmd"] = {["command"] = ':!pandoc -f commonmark_x -t pdf --pdf-engine=xelatex -V mainfont:FreeSans \"%\" | zathura - &', ["options"] = {["desc"] = "Compile current markdown file to pdf and pipe into Zathura"}},
    ["Sw"] = {["command"] = ":SudaWrite", ["options"] = {["desc"] = "Write with sudo privileges"}},
    ["Zmd"] = {["command"] = ':!pkill zathura; zathura /tmp/\"%:t:r\" &', ["options"] = {["desc"] = "Read current pdf in /tmp with Zathura"}}}
  for name,cmd in pairs(cmds) do
    vim.api.nvim_create_user_command(name, cmd.command, cmd.options)
  end
end

do
  local keybinds = 
    {{["action"] = "<cmd>Alpha<CR>", ["key"] = "<leader>0", ["mode"] = {"n","v"}},
    {["action"] = "<cmd>Telescope fd<CR>", ["key"] = "<leader>ff", ["mode"] = {"n","v"}},
    {["action"] = "<cmd>Telescope live_grep<CR>", ["key"] = "<leader>fg", ["mode"] = {"n", "v"}},
    {["action"] = "<cmd>NvimTreeToggle<CR>", ["key"] = "<leader>t", ["mode"] = {"n","v"}},
    {["action"] = "<Esc>", ["key"] = "ää", ["mode"] = {"i","v"}}}
  for i, map in ipairs(keybinds) do
    vim.keymap.set(map.mode, map.key, map.action, map.options)
  end
end


vim.loader.disable()
vim.cmd([[
let $BAT_THEME = 'rose-pine'

colorscheme rose-pine

]])
require("mkdnflow").setup({})

local leader = "SPC"
--- @param sc string
--- @param txt string
--- @param keybind string? optional
--- @param keybind_opts table? optional
local function button(sc, txt, keybind, keybind_opts)
  local sc_ = sc:gsub("%s", ""):gsub(leader, "<leader>")

  local opts = {
    position = "center",
    shortcut = sc,
    cursor = 3,
    width = 50,
    align_shortcut = "right",
    hl_shortcut = "Keyword",
  }
  if keybind then
    keybind_opts = vim.F.if_nil(keybind_opts, { noremap = true, silent = true, nowait = true })
    opts.keymap = { "n", sc_, keybind, keybind_opts }
  end

  local function on_press()
    local key = vim.api.nvim_replace_termcodes(keybind or sc_ .. "<Ignore>", true, false, true)
    vim.api.nvim_feedkeys(key, "t", false)
  end

  return {
    type = "button",
    val = txt,
    on_press = on_press,
    opts = opts,
  }
end


do
  local __telescopeExtensions = {}

  require('telescope').setup({})

  for i, extension in ipairs(__telescopeExtensions) do
    require('telescope').load_extension(extension)
  end
end

require("lualine").setup({["options"] = {["icons_enabled"] = true}})
require("luasnip").config.set_config({})


-- LSP {{{
do
  local __lspServers = 
  {
    {["extraOptions"] = {["autostart"] = true}, ["name"] = "pylsp"},
    {["extraOptions"] = {["autostart"] = true}, ["name"] = "nixd"},
    {["extraOptions"] = {["autostart"] = true}, ["name"] = "gdscript"},
    {["extraOptions"] = {["autostart"] = true, ["cmd"] = {"elixir-ls"}}, ["name"] = "elixirls"}
  }

  --{["extraOptions"] = {["autostart"] = true,["cmd"] = {"/nix/store/qk2a9jnbj6wy7gcww69qlzbyv48qgbky-elixir-ls-0.17.10/bin/elixir-ls"}},["name"] = "elixirls"}}
  local __lspOnAttach = function(client, bufnr)
  end
  local __lspCapabilities = function()
    capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require('cmp_nvim_lsp').default_capabilities()
    return capabilities
  end
  local __setup = {
    on_attach = __lspOnAttach,
    capabilities = __lspCapabilities()
  }
  for i,server in ipairs(__lspServers) do
    if type(server) == "string" then
      require('lspconfig')[server].setup(__setup)
    else
      local options = server.extraOptions

      if options == nil then
	options = __setup
      else
	options = vim.tbl_extend("keep", options, __setup)
      end

      require('lspconfig')[server.name].setup(options)
    end
  end
end
-- }}}

require('nvim-treesitter.configs').setup(
  {["highlight"] = {["enable"] = true},
  ["incremental_selection"] = {["enable"] = true,
  ["keymaps"] = {["init_selection"] = "gnn",
  ["node_decremental"] = "grm",
  ["node_incremental"] = "grn",
  ["scope_incremental"] = "grc"}}})
__parserFiltypeMappings = {}

for parser_name, ft in pairs(__parserFiltypeMappings) do
  require('vim.treesitter.language').register(parser_name, ft)
end


require('nvim-tree').setup({})

do
  local cmp = require('cmp')
  cmp.setup({["mapping"] = 
    {["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<Down>"] = cmp.mapping(cmp.mapping.select_next_item(),{"i","s"}),
    ["<S-Tab>"] = cmp.mapping(cmp.mapping.select_prev_item(),{"i","s"}),
    ["<Tab>"] = cmp.mapping(cmp.mapping.select_next_item(),{"i","s"}),
    ["<Up>"] = cmp.mapping(cmp.mapping.select_prev_item(),{"i","s"})},
    ["snippet"] = {["expand"] = "\t  "},
    ["sources"] = {{["name"] = "luasnip"},{["name"] = "nvim_lsp"}, { name = 'nvim_lua' }, {["name"] = "path"},{["name"] = "buffer"}}})
end

-- Set up keybinds {{{
-- }}}


local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")
dashboard.section.header.val = {
  "          ▗▄▄▄       ▗▄▄▄▄    ▄▄▄▖          ",
  "          ▜███▙       ▜███▙  ▟███▛          ",
  "           ▜███▙       ▜███▙▟███▛           ",
  "            ▜███▙       ▜██████▛            ",
  "     ▟█████████████████▙ ▜████▛     ▟▙      ",
  "    ▟███████████████████▙ ▜███▙    ▟██▙     ",
  "           ▄▄▄▄▖           ▜███▙  ▟███▛     ",
  "          ▟███▛             ▜██▛ ▟███▛      ",
  "         ▟███▛               ▜▛ ▟███▛       ",
  "▟███████████▛                  ▟██████████▙ ",
  "▜██████████▛                  ▟███████████▛ ",
  "      ▟███▛ ▟▙               ▟███▛          ",
  "     ▟███▛ ▟██▙             ▟███▛           ",
  "    ▟███▛  ▜███▙           ▝▀▀▀▀            ",
  "    ▜██▛    ▜███▙ ▜██████████████████▛      ",
  "     ▜▛     ▟████▙ ▜████████████████▛       ",
  "           ▟██████▙       ▜███▙             ",
  "          ▟███▛▜███▙       ▜███▙            ",
  "         ▟███▛  ▜███▙       ▜███▙           ",
  "         ▝▀▀▀    ▀▀▀▀▘       ▀▀▀▘           ",
}
dashboard.section.buttons.val = {
  dashboard.button( "e", "  New file" , ":ene <BAR> startinsert <CR>"),
  dashboard.button( "f", "  Find file", ":Telescope find_files<CR>"),
  dashboard.button( "r", "  Recent"   , ":Telescope oldfiles<CR>"),
  dashboard.button( "c", "󰜗  Nix Configuration" , ":e /etc/nixos/configuration.nix<CR>"),
  dashboard.button( "q", "󰿅  Quit Nixvim", ":qa!<CR>"),
}
alpha.setup(dashboard.opts)
vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])

do
  local cmp = require('cmp')
  cmp.setup({
    ["snippet"] = {["expand"] = function(args) require('luasnip').lsp_expand(args.body)  end},
  })
end


