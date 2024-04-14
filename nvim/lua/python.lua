--pythonh configuration
--
vim.g.slime_target = "tmux"
vim.g.slime_tmux_session = "python-session"
vim.g.slime_tmux_socket_name = nil
vim.g.slime_tmux_pane = "python-pane"

local function findPythonVirtualEnv()
  local current_dir = vim.fn.getcwd()
  local files = vim.fn.readdir(current_dir)

  -- Iterate over files in the current directory
  for _, file in ipairs(files) do
    -- Check if the file is a directory
    if vim.fn.isdirectory(current_dir .. "/" .. file) == 1 then
      -- Check if the directory contains necessary Python files or folders
      if vim.fn.isdirectory(current_dir .. "/" .. file .. "/bin") == 1 and vim.fn.filereadable(current_dir .. "/" .. file .. "/bin/python") == 1 then
        return current_dir .. "/" .. file
      end
    end
  end

  return nil
end
local function getPythonCmd()
  local cmd = ". .venv/bin/activate && python3"
  local venv_path = findPythonVirtualEnv()
  if venv_path then
    print("Found venv path: ", venv_path)
    cmd = string.format(". %s/bin/activate && python3", venv_path)
  else
    cmd = "python3"
  end
  print("Python cmd: ", cmd)
  return cmd
end

function TogglePythonSession()
  local session = vim.g.slime_tmux_session
  local pane = vim.g.slime_tmux_pane
  local python_cmd = getPythonCmd()
  local create_session_cmd = string.format("tmux new-session  -s %s -n %s '%s' ", session, pane, python_cmd)
  local session_exists = vim.fn.system(string.format("tmux has-session -t %s", session))
  if session_exists == "" then
    print("Session exists. Closing it.")
    os.execute(string.format("tmux kill-session -t %s", session))
    vim.api.nvim_command("bdelete! " .. session)
  else
    print("Session doesn't exist. Starting a new one.")
    vim.api.nvim_command(":vs | :te " .. create_session_cmd)
    vim.api.nvim_command("wincmd p")
  end
end
vim.api.nvim_set_keymap("n", "<F5>", ":lua TogglePythonSession()<CR>", { noremap = true, silent = true })

local function SetupTmuxSessionKiller()
  local session_name = vim.g.slime_tmux_session
  local autocmd_block = string.format(
    [[
        augroup KillTmuxSessionOnQuit
            autocmd!
            autocmd VimLeave * !tmux kill-session -t %s
        augroup END
    ]],
    session_name
  )
  vim.cmd(autocmd_block)
end
SetupTmuxSessionKiller()
