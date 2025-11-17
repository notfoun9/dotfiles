vim.cmd("set tabstop=4")
vim.cmd("set expandtab")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")
vim.cmd("set nu rnu")
vim.cmd("set colorcolumn=80")
vim.cmd("cabb W w")
vim.cmd("cabb hs split")

vim.cmd("tnoremap <Esc> <C-\\><C-n>")
vim.g.mapleader = " "

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system(
      {
          "git",
          "clone",
          "--filter=blob:none",
          "--branch=stable",
          lazyrepo,
          lazypath
      }
  )

  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local plugins= {
    {
        "catppuccin/nvim", name = "catppuccin", priority = 1000
    },
    {
        'nvim-telescope/telescope.nvim', tag = '0.1.8',
         requires = {'nvim-lua/plenary.nvim'}
    },
    {
        "nvim-neo-tree/neo-tree.nvim", branch = "v3.x",
        dependencies =
        {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim"
        }
    },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' }
    },
    {
        "williamboman/mason.nvim"
    },
    {
        "williamboman/mason-lspconfig.nvim"
    },
    {
        "neovim/nvim-lspconfig"
    },
    {
        'nvim-telescope/telescope-ui-select.nvim'
    },
    {
        'hrsh7th/nvim-cmp'
    },
    {
        'L3MON4D3/LuaSnip',
        dependencies = {
            'saadparwaiz1/cmp_luasnip',
            "rafamadriz/friendly-snippets"
        }
    },
    {
        "hrsh7th/cmp-nvim-lsp"
    },
    {
        "mbbill/undotree"
    },
    {
        "mg979/vim-visual-multi",
        init = function ()
            vim.g.VM_default_mapping = 0
            vim.g.VM_maps = {
                ['Find Under'] = ''
            }
            vim.g.VM_add_cursor_at_pos_no_mappings = 1
        end,
    },
    {
        'ThePrimeagen/vim-be-good'
    },
    {
        'nvim-lua/plenary.nvim'
    },
    {
        'ThePrimeagen/harpoon'
    },
    {
        'ggandor/leap.nvim',
        dependencies = {
            'tpope/vim-repeat'
        },
        lazy = false,
    },
}

-- Setup lazy.nvim
require("lazy").setup(plugins, opts)
local builtin = require("telescope.builtin")
require("telescope").setup {
  extensions = {
    ["ui-select"] = {
      require("telescope.themes").get_dropdown {
      }
    }
  }
}
require("telescope").load_extension("ui-select")

local capabilities = require('cmp_nvim_lsp').default_capabilities()
local lspconfig = require('lspconfig')

require("mason").setup()
require('lspconfig').clangd.setup{
    cmd = {"clangd", "cmake", "rust_analyzer"},
    filetypes = { "c", "cpp", "cc", "h", "hpp" },
    init_options = {
        fallbackFlags = {'-std=c++20'}
    }
}
require('lspconfig').rust_analyzer.setup{
    cmd = {"rust_analyzer"},
    filetypes = { "rc" }
}

require("mason-lspconfig").setup({
    ensure_installed = { "lua_ls", "cmake", "jedi_language_server"}
})

lspconfig.lua_ls.setup({
    capabilities = capabilities
})

lspconfig.clangd.setup({
    capabilities = capabilities
})

lspconfig.rust_analyzer.setup({
    capabilities = capabilities
})

lspconfig.cmake.setup({
    capabilities = capabilities
})

lspconfig.jedi_language_server.setup({
    capabilities = capabilities
})

-- require("vim-visual-multi").setup()
require('lualine').setup()
require("catppuccin").setup()
vim.cmd("colorscheme catppuccin")

local cmp = require'cmp'
require("luasnip.loaders.from_vscode").lazy_load()
  cmp.setup({
    snippet = {
      expand = function(args)
        require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
      end,
    },
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = false}),
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'luasnip' }, -- For luasnip users.
    }, {
      { name = 'buffer' },
    })
  })

  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

local status = 3
local function toggle_laststatus()
    if status == 0 then
        status = 1
        vim.cmd("set laststatus=3")
        vim.cmd("set cmdheight=1")
    else
        status = 0
        vim.cmd("set cmdheight=0")
        vim.cmd("set laststatus=0")
    end
end

local num = true
local function toggle_num()
    if num == false then
        num = true
        vim.cmd("set number")
        vim.cmd("set relativenumber")
    else
        num = true
        vim.cmd("set relativenumber!")
        vim.cmd("set number!")
    end
end

local show_diagnostic = true
local function toggle_diagnostic()
    if show_diagnostic == false then
        show_diagnostic = true
        vim.diagnostic.config({virtual_text = true})
    else
        show_diagnostic = false
        vim.diagnostic.config({virtual_text = false})
    end
end

local colorcolumn = true
local function toggle_colorcolumn_80()
    if colorcolumn == false then
        colorcolumn = true
        vim.cmd("set colorcolumn=80")
    else
        colorcolumn = false
        vim.cmd("set colorcolumn=0")
    end
end

local function is_quickfix_window()
  local current_win_id = vim.api.nvim_get_current_win()
  local current_buf_id = vim.api.nvim_win_get_buf(current_win_id)

  local qflist = vim.fn.getqflist({ winid = 0 })

  if qflist and qflist.winid ~= 0 then
    local quickfix_buf_id = vim.api.nvim_win_get_buf(qflist.winid)
    return current_buf_id == quickfix_buf_id
  end

  return false
end

local function enter_remapping()
    if is_quickfix_window() then
        vim.cmd(".cc")
    else
        vim.cmd("put =''")
    end
end

--interface toggle keymaps
vim.keymap.set('n', '<leader>n', toggle_num, {})           -- toggle line numbers
vim.keymap.set('n', '<leader>s', toggle_laststatus, {})    -- toggle vim status line
vim.keymap.set('n', '<leader>d', toggle_diagnostic, {})    -- toggle show diagnostic messages
vim.keymap.set('n', '<leader>u', ':UndotreeToggle<CR>', {})
vim.keymap.set('n', '<leader>b', ':Neotree filesystem toggle right<CR>', {}) -- open filesystem menu
vim.keymap.set('n', '<leader>c',  toggle_colorcolumn_80, {})

--default vim commands qol improvements/remaps
vim.keymap.set('n', 'J',  '5<C-e>',{})                     -- scroll down
vim.keymap.set('n', 'K',  '5<C-y>',{})                     -- scroll up
vim.keymap.set('n', '<Enter>', enter_remapping,{})         -- add line below or choose option if in quickfix
vim.keymap.set('n', '<leader><Enter>', 'O<ESC>',{})        -- add line above
vim.keymap.set('n', '<leader>[', 'o{<CR>}<ESC>k',{})       -- create new cirly braces beneath
vim.keymap.set('n', '<leader>\'', ':noh<CR>:nohls<CR>',{}) -- go to definition location
vim.keymap.set('n', '<leader>v',  ':vs<CR><C-w>l',{})      -- vertical split and go left
vim.keymap.set('n', '<leader>q',  ':q<CR>',{})             -- quit

--motion keymaps
vim.keymap.set('n', '<leader>l',  '<C-w>l',{})
vim.keymap.set('n', '<leader>h',  '<C-w>h',{})
vim.keymap.set('n', '<leader>j',  '<C-w>j',{})
vim.keymap.set('n', '<leader>k',  '<C-w>k',{})

--telescope keymaps
vim.keymap.set('n', '<leader>p', ':Telescope find_files theme=ivy<CR>', {})     -- find
vim.keymap.set('n', '<leader>g', ':Telescope live_grep theme=ivy<CR>', {})      -- grep
vim.keymap.set('n', '<leader>r', ':Telescope lsp_references theme=ivy<CR>', {}) -- refs
vim.keymap.set('n', '<leader>m', ':Telescope marks theme=ivy<CR>', {})          -- marks

--lsp keymaps
vim.keymap.set('n', '<leader>i', vim.lsp.buf.hover, {})
vim.keymap.set('n', '<leader>\\', vim.lsp.buf.definition, {})

--harpoon keymaps
vim.keymap.set('n', '<leader>;', ':lua require("harpoon.ui").toggle_quick_menu()<CR>', {})
vim.keymap.set('n', '<leader>a', ':lua require("harpoon.mark").add_file()<CR>', {})
vim.keymap.set('n', '<leader>1', ':lua require("harpoon.ui").nav_file(1)<CR>', {})
vim.keymap.set('n', '<leader>2', ':lua require("harpoon.ui").nav_file(2)<CR>', {})
vim.keymap.set('n', '<leader>3', ':lua require("harpoon.ui").nav_file(3)<CR>', {})
vim.keymap.set('n', '<leader>4', ':lua require("harpoon.ui").nav_file(4)<CR>', {})
vim.keymap.set('n', '<leader>5', ':lua require("harpoon.ui").nav_file(5)<CR>', {})
vim.keymap.set('n', '<leader>6', ':lua require("harpoon.ui").nav_file(6)<CR>', {})
vim.keymap.set('n', '<leader>7', ':lua require("harpoon.ui").nav_file(7)<CR>', {})
vim.keymap.set('n', '<leader>8', ':lua require("harpoon.ui").nav_file(8)<CR>', {})
vim.keymap.set('n', '<leader>9', ':lua require("harpoon.ui").nav_file(9)<CR>', {})
vim.keymap.set('n', '<leader>0', ':lua require("harpoon.ui").nav_file(10)<CR>', {})

--leap keymaps (":h leap-custom-mapping" for reference)
vim.keymap.set({'n', 'x', 'o'}, 's', '<Plug>(leap)')
vim.keymap.set('n',             'S', '<Plug>(leap-from-window)')
vim.keymap.set('n',             's', '<Plug>(leap-anywhere)')
vim.keymap.set({'x', 'o'},      's', '<Plug>(leap)')
vim.keymap.set({'n', 'x', 'o'}, 's',  '<Plug>(leap-forward)')
vim.keymap.set({'n', 'x', 'o'}, 'S',  '<Plug>(leap-backward)')
vim.keymap.set({'n', 'x', 'o'}, 'gs', '<Plug>(leap-from-window)')
