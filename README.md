# Neovim setup

My personal Neovim setup written in lua.


TODO:
- add folding: I can use this article to set it up https://alpha2phi.medium.com/neovim-for-beginners-code-folding-7574925412ea
- look into toolings to see the file tree.
  I want to quickly be able to see how a file is setup.
      - SOLUTION: https://github.com/stevearc/aerial.nvim

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


## Snippets

I followed [this article]() to setup luasnip and to learn how to use it.


## reload
[Add the script from this thread](https://stackoverflow.com/questions/72412720/how-to-source-init-lua-without-restarting-neovim)
