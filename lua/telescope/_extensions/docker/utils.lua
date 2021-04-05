local Job = require('plenary.job')

dutils = {}

-- API helper functions for buffer previewer
--- Job maker for buffer previewer
dutils.job_maker = function(cmd, bufnr, opts)
  opts = opts or {}
  opts.mode = opts.mode or "insert"
  -- bufname and value are optional
  -- if passed, they will be use as the cache key
  -- if any of them are missing, cache will be skipped
  if opts.bufname ~= opts.value or not opts.bufname or not opts.value then
    local command = table.remove(cmd, 1)
    Job:new({
      command = command,
      args = cmd,
      env = opts.env,
      cwd = opts.cwd,
      on_start = function(j)
        j._stdout_stderr_result = {}
        j._stdout_stderr_idx = 1
      end,
      on_stderr = function(err, result_line, j)
        j._stdout_stderr_result[j._stdout_stderr_idx] = result_line
        j._stdout_stderr_idx = j._stdout_stderr_idx + 1
      end,
      on_stdout = function(err, result_line, j)
        j._stdout_stderr_result[j._stdout_stderr_idx] = result_line
        j._stdout_stderr_idx = j._stdout_stderr_idx + 1
      end,
      on_exit = vim.schedule_wrap(function(j)
        if not vim.api.nvim_buf_is_valid(bufnr) then return end
        if opts.mode == "append" then
          vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, j._stdout_stderr_result)
        elseif opts.mode == "insert" then
          vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, j._stdout_stderr_result)
        end
        if opts.callback then opts.callback(bufnr, j._stdout_stderr_result) end
      end)
    }):start()
  else
    if opts.callback then opts.callback(bufnr) end
  end
end

return dutils
