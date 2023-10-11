[neovim lua plugin from scratch](https://www.youtube.com/watch?v=n4Lp4cV8YR0&t=461s)
* plugins in neovim are just repositories (and repositories are just folders with .git folder).

What is a vim runtime?
* see help 'runtimepath' - `:help 'runtimepath'`

The plugin folder in runtimepath:
All lua code that is located within a plugin folder is executed at neovim start up. So if I put a file called `hallo_world.lua`, 
that contains `print('hallo world')` within a plugin folder somewhere in my lua config then the string `'hallo world'` will be 
executed at neovims start up. This folder (and this functionality) can be used if you want to run something before neovim starts.

