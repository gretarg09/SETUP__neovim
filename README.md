# Neovim setup

My personal Neovim setup written in lua.


TODO:
- add folding: I can use this article to set it up https://alpha2phi.medium.com/neovim-for-beginners-code-folding-7574925412ea
- add lsp support for terraform.
- look into toolings to see the file tree.
  I want to quickly be able to see how a file is setup.
      - SOLUTION: https://github.com/stevearc/aerial.nvim
- setup my nodes in github and write it locally using markdown viewer. See https://jdhao.github.io/2019/01/15/markdown_edit_preview_nvim/

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

    

