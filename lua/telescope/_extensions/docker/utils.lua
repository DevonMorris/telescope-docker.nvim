local Job = require('plenary.job')
local finders = require('telescope.finders')
local make_entry = require('telescope._extensions.docker.make_entry')

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
    local output = {}
    Job:new({
      command = command,
      args = cmd,
      env = opts.env,
      cwd = opts.cwd,
      on_stderr = function(_, data)
        table.insert(output, data)
      end,
      on_stdout = function(_, data)
        table.insert(output, data)
      end,
      on_exit = vim.schedule_wrap(function(j)
        if not vim.api.nvim_buf_is_valid(bufnr) then return end
        if opts.mode == "append" then
          vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, output)
        elseif opts.mode == "insert" then
          vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, output)
        end
        if opts.callback then opts.callback(bufnr, output) end
      end)
    }):start()
  else
    if opts.callback then opts.callback(bufnr) end
  end
end

local get_job_from_cmd = function(cmd, cwd)
  if type(cmd) ~= "table" then
    print('Telescope Docker: [get_os_command_output]: cmd has to be a table')
    return {}
  end
  local command = table.remove(cmd, 1)
  return Job:new({ command = command, args = cmd, cwd = cwd})
end
dutils.get_job_from_cmd = get_job_from_cmd

local gen_finder_from_results = function(results, entry_maker)
  return finders.new_table {
    results = results,
    entry_maker = entry_maker
  }
end
dutils.gen_finder_from_results = gen_finder_from_results

local get_container_job = function()
  local job = get_job_from_cmd({
        'docker', 'ps', '-a',  '--format',  '"{{.Names}}\t{{.Image}}\t{{.State}}\t{{.ID}}"'
      })
  return job
end
dutils.get_container_job = get_container_job

dutils.gen_container_finder_sync = function()
  local job = get_container_job()
  return gen_finder_from_results(job:sync(), make_entry.gen_from_containers())
end

local get_image_job = function()
  local job = get_job_from_cmd({
        'docker', 'image', 'ls', '-a', '--format', '"{{.Repository}}\t{{.Tag}}"'
      })
  return job
end
dutils.get_image_job = get_image_job

dutils.gen_image_finder_sync = function()
  local job = get_image_job()
  return gen_finder_from_results(job:sync(), make_entry.gen_from_image())
end

local get_search_job = function(query)
  local job = get_job_from_cmd({
        'docker', 'search', '--limit', '30', '--format',
        '"{{.Name}}\t{{.Description}}\t{{.StarCount}}\t{{.IsOfficial}}"',
        '--no-trunc', query
      })
  return job
end

dutils.gen_search_finder_sync = function(query)
  local job = get_search_job(query)
  return gen_finder_from_results(job:sync(), make_entry.gen_from_search())
end

return dutils
