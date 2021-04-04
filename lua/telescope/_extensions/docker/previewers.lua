local utils = require('telescope.utils')
local putils = require('telescope.previewers.utils')
local previewers = require('telescope.previewers')
local defaulter = utils.make_default_callable

local docker_previewers = {}

docker_previewers.docker_logs = defaulter(function(opts)
  return previewers.new_buffer_previewer {
    get_buffer_by_name = function(_, entry)
      return entry.value
    end,

    define_preview = function(self, entry, status)
      putils.job_maker({ 'docker', 'logs', '-n', 100, entry.name }, self.state.bufnr, {
        value = entry.value,
        bufname = self.state.bufname,
        cwd = opts.cwd
      })
    end
  }
end, {})

return docker_previewers
