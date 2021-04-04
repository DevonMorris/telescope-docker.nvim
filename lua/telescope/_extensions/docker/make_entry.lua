local entry_display = require('telescope.pickers.entry_display')

local make_entry = {}

function make_entry.gen_from_containers()
  local display_items = {
    { width = 30 },       -- Container Name
    { width = 10 },       -- Status
    { remaining = true}   -- Image
  }

  local displayer = entry_display.create {
    separator = " ",
    items = display_items
  }

  local make_display = function(entry)
    return displayer {
      {entry.name, "TelescopeResultsIdentifier"},
      entry.status,
      entry.image
    }
  end

  return function(entry)
    if entry == "" then
      return nil
    end

    local name, image, status, id = string.match(entry, '"([^ ]+)%s+([^ ]+)%s+([^ ]+)%s+([^ ]+)')

    return {
      value = name,
      ordinal = name .. ' ' .. image .. ' ' .. id,
      name = name,
      id = id,
      image = image,
      status = status,
      display = make_display
    }
  end
end

return make_entry
