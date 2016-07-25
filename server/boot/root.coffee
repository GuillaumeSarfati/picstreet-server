module.exports = (server) ->
  # Install a `/` route that returns server status
  router = server.loopback.Router()
  router.get '/api', server.loopback.status()
  server.use router
  return
