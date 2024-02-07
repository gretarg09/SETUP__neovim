-- vim inspect will return a string representation of a table. If you try to print out a 
-- table in lua you will just get the memory referench but not the actual content. Vim.inspect
-- is a way to get the actual content
print('Loaded Globals') 

P = function(v)
  print(vim.inspect(v))
  return v
end
