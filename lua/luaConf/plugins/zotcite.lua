return {
  {
    "zotcite",
    for_cat = "markdown",
    ft = { "markdown", "pandoc", "rmd", "quarto", "tex", "rnoweb" },
    after = function(plugin)
      -- Basic zotcite configuration
      -- Zotcite uses Zotero's better-bibtex integration
      
      -- Set citation key format (default is {Author}-{Year})
      -- Options: {author}/{Author} (lowercase/titlecase), {authors}/{Authors} (first 3 authors), {year}/{Year} (2/4 digits)
      -- vim.g.zotcite_citation_template = '{Author}-{year}'
      
      -- Set conceallevel for citation keys (default is 2)
      vim.g.zotcite_conceallevel = 2
      
      -- Note: To insert citations, use <C-X><C-B> in insert mode
      -- This triggers Vim's omnifunc completion with zotcite
      
      -- Keybindings for working with existing citations (cursor over citation key)
      local opts = { noremap = true, silent = true }
      
      -- Open Zotero attachment (default: <Leader>zo)
      vim.keymap.set('n', '<leader>zo', '<Plug>ZOpenAttachment', 
        vim.tbl_extend('force', opts, { desc = 'Open Zotero attachment' }))
      
      -- Show citation info in status bar (default: <Leader>zi)
      vim.keymap.set('n', '<leader>zi', '<Plug>ZCitationInfo', 
        vim.tbl_extend('force', opts, { desc = 'Show citation info' }))
      
      -- Show all citation fields (default: <Leader>za)
      vim.keymap.set('n', '<leader>za', '<Plug>ZCitationCompleteInfo', 
        vim.tbl_extend('force', opts, { desc = 'Show complete citation info' }))
      
      -- Insert abstract into buffer (default: <leader>zb)
      vim.keymap.set('n', '<leader>zb', '<Plug>ZExtractAbstract', 
        vim.tbl_extend('force', opts, { desc = 'Insert abstract' }))
      
      -- Show YAML reference (default: <Leader>zy)
      vim.keymap.set('n', '<leader>zy', '<Plug>ZCitationYamlRef', 
        vim.tbl_extend('force', opts, { desc = 'Show YAML reference' }))
      
      -- View generated document (default: <Leader>zv)
      vim.keymap.set('n', '<leader>zv', '<Plug>ZViewDocument', 
        vim.tbl_extend('force', opts, { desc = 'View generated document' }))
    end,
  },
}
