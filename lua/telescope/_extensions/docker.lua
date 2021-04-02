return require('telescope').register_extension {
  setup = function(ext_config, config)
  end,

  -- requires = ...
  -- mappings = ...
  -- actions = ...
  -- commands = ...

  exports = {
    docker = function()
      print("hello")
      return 0
    end
  }
}
