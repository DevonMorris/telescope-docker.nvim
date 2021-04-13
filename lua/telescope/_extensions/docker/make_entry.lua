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

function make_entry.gen_from_image()
  local display_items = {
    { width = 50 },       -- Repository
    { width = 30 },       -- Tag
  }

  local displayer = entry_display.create {
    separator = " ",
    items = display_items
  }

  local make_display = function(entry)
    return displayer {
      {entry.repository, "TelescopeResultsIdentifier"},
      entry.tag,
    }
  end

  return function(entry)
    if entry == "" then
      return nil
    end

    local repository, tag = string.match(entry, '"([^ ]+)%s+([^ ]+)"')

    if repository == "<none>" then
      return nil
    end
    if tag == "<none>" then
      return nil
    end

    return {
      value = repository,
      repository = repository,
      ordinal = repository .. ' ' .. tag,
      tag = tag,
      display = make_display
    }
  end
end

function make_entry.gen_from_search()
  local display_items = {
    { width = 30 },       -- Image Name
    { width = 5 },       -- Star Count
    { width = 3 },       -- Is Official
    { remaining = true}   -- Description
  }

  local displayer = entry_display.create {
    separator = " ",
    items = display_items
  }

  local make_display = function(entry)
    return displayer {
      {entry.image, "TelescopeResultsIdentifier"},
      entry.stars,
      entry.is_official,
      entry.description
    }
  end

  return function(entry)
    if entry == "" then
      return nil
    end

    local image, description, stars, is_official =
      string.match(entry, '"([^%s]+)%s+([%w%s%p]+)%s+(%d+)%s+(.*)"')

    if is_official == "[OK]" then
      is_official = "O"
    else
      is_official = "N"
    end

    return {
      value = image,
      ordinal = image,
      image = image,
      is_official = is_official,
      description = description,
      stars = stars,
      display = make_display
    }
  end
end

return make_entry
