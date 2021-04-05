local action_state = require('telescope.actions.state')
local utils = require('telescope.utils')
local Job = require('plenary.job')
local transform_mod = require('telescope.actions.mt').transform_mod
local dactions = {}

dactions.docker_start_toggle = function(prompt_bufnr)
  local cwd = action_state.get_current_picker(prompt_bufnr).cwd
  local selection = action_state.get_selected_entry()

  if selection.status == 'running' then
    utils.get_os_command_output({ 'docker', 'stop', selection.name }, cwd)
  else
    utils.get_os_command_output({ 'docker', 'start', selection.name }, cwd)
  end
end

dactions = transform_mod(dactions)
return dactions
