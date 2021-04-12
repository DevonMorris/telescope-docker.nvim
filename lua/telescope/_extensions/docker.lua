local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
local dactions = require('telescope._extensions.docker.actions')
local dutils = require('telescope._extensions.docker.utils')
local pickers = require('telescope.pickers')
local previewers = require('telescope._extensions.docker.previewers')

local conf = require('telescope.config').values

local containers = function(opts)
  local initial_finder = dutils.gen_container_finder_sync()
  if not initial_finder then return end

  pickers.new(opts, {
    prompt_title = 'Docker Containers',
    finder = initial_finder,
    sorter = conf.file_sorter(opts),
    previewer = previewers.docker_logs.new(opts),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(dactions.docker_shell)

      map('i', '<c-s>', dactions.docker_start_toggle)
      map('n', '<c-s>', dactions.docker_start_toggle)
      map('i', '<c-r>', dactions.docker_rm)
      map('n', '<c-r>', dactions.docker_rm)
      return true
    end
  }):find()
end

local images = function()
  print("images")
end

local search = function(opts)
  local query = opts.query
  if query == nil then
    query = vim.fn.input("Search DockerHub for >")
  end
  local initial_finder = dutils.gen_search_finder_sync(query)
  if not initial_finder then return end

  pickers.new(opts, {
    prompt_title = 'DockerHub Images',
    finder = initial_finder,
    sorter = conf.file_sorter(opts),
    attach_mappings = function(prompt_bufnr, map)
      return true
    end
  }):find()
end

return require('telescope').register_extension {
  setup = function(ext_config, config)
  end,

  -- requires = ...
  -- mappings = ...
  actions = dactions,
  -- commands = ...

  exports = {
    containers = containers,
    images = images,
    search = search,
  }
}
