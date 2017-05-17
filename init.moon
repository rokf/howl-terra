mode_reg =
  name: 'terra'
  extensions: 't'
  create: bundle_load 'terra_mode'

howl.config.define {
  name: 'terra_executable'
  description: 'Terra executable name or path'
  type_of: 'string'
  default: 'terra'
}

howl.command.register {
  name: 'terra-run'
  description: 'Run current file with Terra'
  handler: () ->
    howl.command.run "exec #{howl.config.terra_executable} #{howl.app.editor.buffer.file.basename}"
}

howl.mode.register mode_reg

unload = ->
  howl.command.unregister 'terra-run'
  howl.mode.unregister 'terra'


return {
  info:
    author: 'Rok Fajfar',
    description: 'Terra bundle for Howl',
    license: 'MIT',
  :unload
}
