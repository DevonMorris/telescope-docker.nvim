# Docker Extension For Telescope

## Installation

The usual for telescope extensions in packer,

```lua
use {
  "DevonMorris/telescope-docker.nvim",
  config = function()
    require"telescope".load_extension("docker")
  end
}
```

## Running
You can run this using vim commands like
```
Telescope docker containers
```

of in lua like
```
require('telescope').extensions.docker.containers
```

## TODO
* [ ] Images
  * [ ] Finder
  * [ ] Entry maker
  * [ ] What should I even make the previewer here???
  * [ ] `rmi`
  * [ ] `docker run`
  * [ ] `docker start`
  * [ ] open a shell?
  * [ ] How do I handle all the config stuff?
    * [ ] like `-v`, `--rm` basically everything under `docker run --help`
* [ ] Clean Up
  * [ ] Need to figure out where some of the `utils.lua` stuff should live eventually
  * [ ] Clean up this readme
* [ ] Usability
  * [ ] customizeable mappings
  * [ ] Clean up this README
    * [ ] Add demo
    * [ ] Add customization info
    * [ ] Can I generate vim help pages???
    * [ ] Need a photoshop of whale on telescope
* [ ] Docker Compose???
* [ ] Containers
  * [ ] Arbitrary exec?
