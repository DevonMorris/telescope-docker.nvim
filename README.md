# Docker Extension For Telescope

WIP yayayayayayaya

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
* [ ] Fix actions to not block and update picker
  * [ ] Is this even possible???
    * [ ] I tried to make it an `on_exit` in the job by calling a `picker:refresh` -> segfault
    * [ ] Tried adding another update job `after` and I got some error about not being able to be tied to a callback, but I might have done this wrong, I was tired
  * [ ] Really a problem for `docker stop`
* [ ] Containers
  * [ ] Remove container action
  * [ ] drop to a shell in the container -> `termopen()`
  * [ ] previewer fix ansi codes
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
