vim.cmd("set tabstop=4")
vim.cmd("set expandtab")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")
vim.cmd("set nu rnu")
vim.cmd("cabb W w")
vim.cmd("cabb Wa wa")
vim.cmd("cabb Wq wq")
vim.cmd("cabb Wqa wqa")
vim.cmd("cabb WQa wqa")
vim.cmd("cabb hs split")

vim.diagnostic.config({
    virtual_text = false,
    signs = false,
    update_in_insert = false,
    underline = false
})

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
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {},
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
        'nvim-telescope/telescope-ui-select.nvim'
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
        'hrsh7th/nvim-cmp'
    },
    {
        "hrsh7th/cmp-nvim-lsp"
    },
    {
        'L3MON4D3/LuaSnip',
        dependencies = {
            'saadparwaiz1/cmp_luasnip',
            "rafamadriz/friendly-snippets"
        }
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
require("lazy").setup(plugins, {})
local _ = require("telescope.builtin")
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

require("mason").setup()

-- Define common settings
local on_attach = function(client, bufnr)
    -- You can add common keymaps or settings here if needed
    -- For example:
    -- local opts = { buffer = bufnr }
    -- vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
end

-- Configure each server using the new API
vim.lsp.config('clangd', {
    cmd = { "clangd" },
    filetypes = { "c", "cpp", "cc", "h", "hpp" },
    capabilities = capabilities,
    on_attach = on_attach,
})

vim.lsp.config('rust_analyzer', {
    cmd = { "rust_analyzer" },
    filetypes = { "rust" },  -- Fixed: should be "rust", not "rc"
    capabilities = capabilities,
    on_attach = on_attach,
})

vim.lsp.config('gopls', {
    cmd = { "gopls" },
    filetypes = { "go" },
    capabilities = capabilities,
    on_attach = on_attach,
})

vim.lsp.config('lua_ls', {
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
        Lua = {
            runtime = { version = 'LuaJIT' },
            diagnostics = { globals = { 'vim' } },
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
            },
            telemetry = { enable = false },
        }
    }
})

vim.lsp.config('cmake', {
    capabilities = capabilities,
    on_attach = on_attach,
})

vim.lsp.config('jedi_language_server', {
    capabilities = capabilities,
    on_attach = on_attach,
})

-- Enable all configured servers
vim.lsp.enable({
    'clangd',
    'rust_analyzer',
    'gopls',
    'lua_ls',
    'cmake',
    'jedi_language_server',
})

-- Mason LSP config remains for ensuring installations
require("mason-lspconfig").setup({
    ensure_installed = { "lua_ls", "cmake", "jedi_language_server", "gopls" },
})

-- require("vim-visual-multi").setup()
require('lualine').setup()
require("catppuccin").setup()
require("tokyonight").setup()
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

local status = 1
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
        num = false
        vim.cmd("set relativenumber!")
        vim.cmd("set number!")
    end
end

local show_diagnostic = false
local function toggle_diagnostic()
    if show_diagnostic == false then
        show_diagnostic = true
        vim.diagnostic.config({
            virtual_text = true,
            signs = true,
            update_in_insert = true,
            underline = true
        })
    else
        show_diagnostic = false
        vim.diagnostic.config({
            virtual_text = false,
            signs = false,
            update_in_insert = false,
            underline = false
        })
    end
end

local colorcolumn = false
local function toggle_colorcolumn_80()
    if colorcolumn == false then
        colorcolumn = true
        vim.cmd("set colorcolumn=80")
    else
        colorcolumn = false
        vim.cmd("set colorcolumn=0")
    end
end

local filesystem_opened = false
local function toggle_filesystem()
    if filesystem_opened == true then
        filesystem_opened = false
    else
        filesystem_opened = true
    end
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(":Neotree filesystem toggle right<CR>", true, true, true), 'n', false)
end

local zoomed = false
local function zoom()
    if filesystem_opened == true then
        toggle_filesystem()
    end
    zoomed = true
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-w>|", true, true, true), 'n', false)
end

local function unzoom()
    zoomed = false
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-w>=", true, true, true), 'n', false)
end

local function toggle_zoom()
    if zoomed == false then
        zoom()
    else
        unzoom()
    end
end

local function goto_left_window()
    if zoomed then
        unzoom()
    end
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-w>h", true, true, true), 'n', false)
end

local function goto_right_window()
    if zoomed then
        unzoom()
    end
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-w>l", true, true, true), 'n', false)
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

local function is_current_window_terminal()
    return vim.bo.buftype == 'terminal'
end

local function close()
    if is_current_window_terminal() == true then
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("aexit<CR>", true, true, true), 'n', false)
    else
        vim.cmd('quit')
    end
end

local codestyle = "new_string"
local function toggle_codestyle()
    if codestyle == "new_string" then
        codestyle = "current_string"
    else
        codestyle = "new_string"
    end
end

local function create_curly_braces()
    if codestyle == "new_string" then
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("o{<CR>}<ESC>k$", true, true, true), 'n', false)
    else
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("A {<ESC>o}<ESC>k$", true, true, true), 'n', false)
    end
end


--single untyped keymap
vim.keymap.set('n', '<leader>e', ':te<CR>amake -C build<CR>', {})

--interface toggle keymaps
vim.keymap.set('n', '<leader>q', close, {})
vim.keymap.set('n', '<leader>t', ':wa<CR>:te<CR>', {})
vim.keymap.set('n', '<leader>n', toggle_num, {})           -- toggle line numbers
vim.keymap.set('n', '<leader>s', toggle_laststatus, {})    -- toggle vim status line
vim.keymap.set('n', '<leader>d', toggle_diagnostic, {})    -- toggle show diagnostic messages
vim.keymap.set('n', '<leader>u', ':UndotreeToggle<CR>', {})
vim.keymap.set('n', '<leader>b', toggle_filesystem, {})
vim.keymap.set('n', '<leader>c',  toggle_colorcolumn_80, {})

vim.keymap.set('n', '<leader>]', toggle_codestyle,{})
vim.keymap.set('n', '<leader>[', create_curly_braces,{})

--default vim commands qol improvements/remaps
vim.keymap.set('n', 'J',  '5<C-e>',{})                     -- scroll down
vim.keymap.set('n', 'K',  '5<C-y>',{})                     -- scroll up
vim.keymap.set('n', '<Enter>', enter_remapping,{})         -- add line below or choose option if in quickfix
vim.keymap.set('n', '<leader><Enter>', 'O<ESC>',{})        -- add line above
vim.keymap.set('n', '<leader>\'', ':noh<CR>:nohls<CR>',{}) -- go to definition location
vim.keymap.set('n', '<leader>v',  ':vs<CR><C-w>l',{})      -- vertical split and go left

--motion keymaps
vim.keymap.set('n', '<leader>z',  toggle_zoom,{})
vim.keymap.set('n', '<leader>l',  goto_right_window,{})
vim.keymap.set('n', '<leader>h',  goto_left_window,{})
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
vim.keymap.set('n', '<leader>.', function() vim.lsp.buf.code_action() end, {})

