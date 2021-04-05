local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
local dactions = require('telescope._extensions.docker.actions')
local finders = require('telescope.finders')
local make_entry = require('telescope._extensions.docker.make_entry')
local pickers = require('telescope.pickers')
local previewers = require('telescope._extensions.docker.previewers')
local utils = require('telescope.utils')

local conf = require('telescope.config').values

local containers = function(opts)
  local results = utils.get_os_command_output({
  'docker', 'ps', '-a',  '--format',  '"{{.Names}}\t{{.Image}}\t{{.State}}\t{{.ID}}"'
  }, opts.cwd)

  pickers.new(opts, {
    prompt_title = 'Docker Containers',
    finder = finders.new_table {
      results = results,
      entry_maker = opts.entry_maker or make_entry.gen_from_containers(opts),
    },
    sorter = conf.file_sorter(opts),
    previewer = previewers.docker_logs.new(opts),
    attach_mappings = function(prompt_bufnr, map)
      map('i', '<c-s>', dactions.docker_start_toggle)
      map('n', '<c-s>', dactions.docker_start_toggle)
      return true
    end
  }):find()
end

local images = function()
  print("images")
end

return require('telescope').register_extension {
  setup = function(ext_config, config)
  end,

  -- requires = ...
  -- mappings = ...
  -- actions = ...
  -- commands = ...

  exports = {
    containers = containers,
    images = images,
  }
}
