pm2 = require 'pm2'

pm2.connect (err) ->
  if err
    console.error err
    process.exit 2
  
  pm2.start
    name: 'PicStreet'
    script: 'server/server.coffee'
    watch: ['./server', './common']
    exec_mode: 'fork'
    instances: 1
    autorestart: true

  , (err, apps) ->
    console.log 'PicStreet server has been Started.\n'
