mode_reg =
  name: 'terra'
  extensions: 't'
  create: bundle_load('terra_mode')

howl.mode.register(mode_reg)

unload = -> howl.mode.unregister 'terra'

return {
  info:
    author: 'Rok Fajfar',
    description: 'Terra bundle for Howl',
    license: 'MIT',
  :unload
}
