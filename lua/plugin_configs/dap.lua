-- This requires the ~/.virtualenvs folder to exist and contain a virtual environment where the debugpy has been installed
--  For more information see: https://github.com/mfussenegger/nvim-dap-python
--  dab = debugger adapter protocol


local status_ok, dap_python = pcall(require, 'dap-python') 
if not status_ok then
    vim.notify(status_ok)
end

dap_python.setup('~/.virtualenvs/debugpy/bin/python')
dap_python.test_runner = 'pytest'
