call plug#begin()
Plug 'godlygeek/tabular'
Plug 'preservim/vim-markdown'
Plug 'folke/tokyonight.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'jbyuki/nabla.nvim'
Plug 'jbyuki/venn.nvim'
Plug 'junegunn/fzf'
Plug 'BurntSushi/ripgrep'
Plug 'sharkdp/fd'
Plug 'jakewvincent/mkdnflow.nvim'
Plug 'nvim-tree/nvim-web-devicons' " optional
Plug 'nvim-tree/nvim-tree.lua'
Plug 'nvim-lua/plenary.nvim'
call plug#end()

autocmd FileType markdown set autowriteall
autocmd FileType markdown lua require("nabla").enable_virt({autogen = true, silent = true})

set clipboard=unnamedplus
let mapleader = ","
let g:vim_markdown_folding_disabled = 1
set virtualedit=all
"nnoremap <leader>m :lua  <CR> Customize with popup({border = ...})  : `single` (default), `double`, `rounded`
command Nt NvimTreeToggle
command Ntf NvimTreeFocus
command Config e ~/.config/nvim/init.vim
"nnoremap <A-M-P> :lua require("nabla").popup() <CR>
nnoremap <C-P> a[[<Esc>p<S-f>[ldw<S-e>a 
imap <C-P> [[<Esc>p<S-f>[ldw<S-e>a
map <F4> <Esc> <S-f>[ldw<S-e>
lua <<EOF
vim.cmd[[colorscheme tokyonight-night]]
-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- empty setup using defaults
require("nvim-tree").setup()
--require("nabla").enable_virt({
--  autogen = true, -- auto-regenerate ASCII art when exiting insert mode
--  silent = true,     -- silents error messages
--})

require("mkdnflow").setup({
	links = {
	    style = 'wiki',
   	    conceal = true,
	    transform_implicit =  function(input)
	    	return('~/Notes/'..input)
	    end
	}

})                             

-- venn.nvim: enable or disable keymappings
function _G.Toggle_venn()
    local venn_enabled = vim.inspect(vim.b.venn_enabled)
    if venn_enabled == "nil" then
        vim.b.venn_enabled = true
        vim.cmd[[setlocal ve=all]]
        -- draw a line on HJKL keystokes
        vim.api.nvim_buf_set_keymap(0, "n", "J", "<C-v>j:VBox<CR>", {noremap = true})
        vim.api.nvim_buf_set_keymap(0, "n", "K", "<C-v>k:VBox<CR>", {noremap = true})
        vim.api.nvim_buf_set_keymap(0, "n", "L", "<C-v>l:VBox<CR>", {noremap = true})
        vim.api.nvim_buf_set_keymap(0, "n", "H", "<C-v>h:VBox<CR>", {noremap = true})
        -- draw a box by pressing "f" with visual selection
        vim.api.nvim_buf_set_keymap(0, "v", "f", ":VBox<CR>", {noremap = true})
    else
        vim.cmd[[setlocal ve=]]
        vim.cmd[[mapclear <buffer>]]
        vim.b.venn_enabled = nil
    end
end
-- toggle keymappings for venn using <leader>v
vim.api.nvim_set_keymap('n', '<leader>v', ":lua Toggle_venn()<CR>", { noremap = true})
EOF
