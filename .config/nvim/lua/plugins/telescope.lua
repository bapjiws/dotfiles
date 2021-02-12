local actions = require('telescope.actions')	

require('telescope').setup{	
  defaults = {	
    mappings = {	
      i = {	
        ["<C-j>"] = actions.move_selection_next,	
        ["<C-k>"] = actions.move_selection_previous,	
        ["<esc>"] = actions.close,	
      },	
      n = {	
        ["<C-j>"] = actions.move_selection_next,	
        ["<C-k>"] = actions.move_selection_previous,	
        ["<esc>"] = actions.close,	
      },	
    },	
    -- See https://github.com/BurntSushi/ripgrep/blob/master/complete/_rg for all options.
    vimgrep_arguments = {	
      'rg',	
      '--color=auto',	
      '--no-heading',	
      '--with-filename',	
      '--line-number',	
      '--column',	
      '--smart-case'	
    },	
    prompt_position = "bottom",	
    prompt_prefix = ">",	
    selection_strategy = "reset",	
    sorting_strategy = "descending",	
    layout_strategy = "horizontal",	
    layout_defaults = {	
      -- TODO add builtin options.	
    },	
    file_sorter =  require'telescope.sorters'.get_fuzzy_file,	
    file_ignore_patterns = {},	
    generic_sorter =  require'telescope.sorters'.get_generic_fuzzy_sorter,	
    shorten_path = true,	
    winblend = 0,	
    width = 0.75,	
    preview_cutoff = 120,	
    results_height = 1,	
    results_width = 0.8,	
    border = {},	
    borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰'},	
    color_devicons = true,	
    use_less = true,	
    set_env = { ['COLORTERM'] = 'truecolor' }, -- default { }, currently unsupported for shells like cmd.exe / powershell.exe	
    file_previewer = require'telescope.previewers'.vim_buffer_cat.new,	
    grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,	
    qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new,	
  }	
}
