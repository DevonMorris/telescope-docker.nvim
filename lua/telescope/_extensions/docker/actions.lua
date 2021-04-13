local action_state = require('telescope.actions.state')
local utils = require('telescope.utils')
local dutils = require('telescope._extensions.docker.utils')
local transform_mod = require('telescope.actions.mt').transform_mod
local dactions = {}

dactions.docker_start_toggle = function(prompt_bufnr)
  local cwd = action_state.get_current_picker(prompt_bufnr).cwd
  local selection = action_state.get_selected_entry()

  local cmd = ""
  if selection.status == 'running' then
    cmd = "stop"
  else
    cmd = "start"
  end

  local results = {}
  local docker_job = dutils.get_job_from_cmd({ 'docker', cmd, selection.name }, cwd)
  local container_job = dutils.get_container_job()
  container_job:after(vim.schedule_wrap(function(j)
    results = j:result()
    local picker = action_state.get_current_picker(prompt_bufnr)
    if picker == nil then
      return
    end
    picker:refresh(dutils.gen_container_finder_from_results(results), { reset_prompt = false })
  end))
  docker_job:and_then(container_job)
  docker_job:start()
end

dactions.docker_rm = function(prompt_bufnr)
  local cwd = action_state.get_current_picker(prompt_bufnr).cwd
  local selection = action_state.get_selected_entry()

  if selection.status == 'running' then
    local confirmation = vim.fn.input('Do you really want to remove running container ' .. selection.name .. '? [Y/n] ')
    if confirmation ~= '' and string.lower(confirmation) ~= 'y' then return end
  end
  local docker_job = dutils.get_job_from_cmd({ 'docker', 'rm', '-f', selection.name }, cwd)
  local container_job = dutils.get_container_job()
  container_job:after(vim.schedule_wrap(function(j)
    local results = j:result()
    local picker = action_state.get_current_picker(prompt_bufnr)
    if picker == nil then
      return
    end
    picker:refresh(dutils.gen_container_finder_from_results(results), { reset_prompt = false })
  end))
  docker_job:and_then(container_job)
  docker_job:start()
end

dactions.docker_shell = function(prompt_bufnr)
  local selection = action_state.get_selected_entry()
  local docker_cmd = 'docker exec -it ' .. selection.name .. ' /bin/bash'

  vim.cmd('term! ' .. docker_cmd)
  vim.cmd('stopinsert')
end

dactions.docker_pull = function(prompt_bufnr)
  local selection = action_state.get_selected_entry()
  local docker_job = dutils.get_job_from_cmd({ 'docker', 'pull', selection.image }, cwd)
  docker_job:add_on_exit_callback(vim.schedule_wrap(function(j, code, signal)
    -- something goes here
    if code ~= 0 then
      print("Failed to pull " .. selection.image)
    else
      print("Successfully pulled " .. selection.image)
    end
  end))
  docker_job:start()
  local picker = action_state.get_current_picker(prompt_bufnr)
  picker:close_existing_pickers()
end

dactions = transform_mod(dactions)
return dactions
