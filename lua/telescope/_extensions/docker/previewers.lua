local utils = require('telescope.utils')
local dutils = require('telescope._extensions.docker.utils')
local previewers = require('telescope.previewers')
local defaulter = utils.make_default_callable

local docker_previewers = {}

docker_previewers.docker_logs = defaulter(function(opts)
  return previewers.new_buffer_previewer {
    get_buffer_by_name = function(_, entry)
      return entry.value
    end,

    define_preview = function(self, entry, status)
      dutils.job_maker({ 'docker', 'logs', '-n', '1000', entry.name }, self.state.bufnr, {
        value = entry.value,
        bufname = self.state.bufname,
        cwd = opts.cwd,
        callback = function(bufnr)
          vim.api.nvim_buf_call(bufnr, function ()
            vim.cmd'silent! %s/[^[:print:]\t]//g'
            vim.cmd'norm G'
          end)
        end
      })
    end
  }
end, {})

return docker_previewers
