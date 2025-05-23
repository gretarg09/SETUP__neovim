# Neovim setup

My personal Neovim setup written in lua.


TODO:
- add folding: I can use this article to set it up https://alpha2phi.medium.com/neovim-for-beginners-code-folding-7574925412ea
- look into toolings to see the file tree.
  I want to quickly be able to see how a file is setup.
      - SOLUTION: https://github.com/stevearc/aerial.nvim -- Done
- Change over to using lazy.nvim. I think its probably best to remove neovim, reinstall the newest stable version and then install all plugins using lazy.nvim.
- [Debugging in Javascript](https://miguelcrespo.co/posts/debugging-javascript-applications-with-neovim/)

LEARNINGS:
- I need to take a lua course on udemy to understand the language better.




## Updating neovim on Ubuntu
----------------------

Clone the repository and read the readme file. It is always best to simple install it from source.


## Issue with tree-sitter-cli
---------------------------

* Take a look at the [gitpage](https://github.com/tree-sitter/tree-sitter/tree/master/cli)
    * install with ```npm install tree-sitter-cli -g```
        * The ```-g``` is the global flag. I want tree sitter cli to be globally 
          available
    * You can see all packages that are installed with npm using ```npm list`` and ```npm list -g```

    

## IDEAs

* I want to be able to create a keybinding that runs the doctest of a given file.
It should open up a terminal in nvim and run the doctest there.
* It would also be nice to be able to run a test by pressing some keybinding if I am 
inside a test file.
* Fix the interactive box in the debugger.
* Take a look at nvim-ipy. I want to be able to execute python code from insite vim.


## Snippets

I followed [this article]() to setup luasnip and to learn how to use it.


## reload
[Add the script from this thread](https://stackoverflow.com/questions/72412720/how-to-source-init-lua-without-restarting-neovim)


# Notes

* **[01-08-2024]**:  The plugin nullls will not be maintained anymore. I will take it out. There where only two keybindings that i was using there. 
```lua 
--# Keybindings
vim.cmd('map <Leader>lf :lua vim.lsp.buf.formatting_sync(nil, 10000)<CR>')
vim.cmd('map <Leader>lF :lua vim.lsp.buf.range_formatting()<CR>')
```
It would be interesting to investigate these functions further to see if they can be used.




