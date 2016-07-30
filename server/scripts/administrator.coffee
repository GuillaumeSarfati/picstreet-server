
server = require '../server'
async = require 'async'

Photographer = server.models.Photographer
Role = server.models.Role
RoleMapping = server.models.RoleMapping

  
Photographer.create [
  {firstname: 'Administrator', lastname: 'Staff',   email: 'administrator@picstreet.io',   password: 'azerty'}
  {firstname: 'Manager', lastname: 'Staff',   email: 'manager@picstreet.io',   password: 'azerty'}
  {firstname: 'Photographer', lastname: 'Staff',   email: 'photographer@picstreet.io',   password: 'azerty'}
]
, (err, photographers) ->
    console.log 'Create photographers success' unless err

    Role.create [
      {name: '$administrator'}
      {name: '$manager'}
      {name: '$photographer'}
    ]
    , (err, roles) ->
      
      console.log 'Create roles success' unless err

      newRoles = []

      
      async.waterfall [

        (done) ->

          RoleMapping.create
            principalType: RoleMapping.USER,
            principalId: photographers[0].id
            roleId: roles[0].id

          , (err, principal) ->
            done err

        (done) ->

          RoleMapping.create
            principalType: RoleMapping.USER,
            principalId: photographers[1].id
            roleId: roles[1].id

          , (err, principal) ->
            done err

        (done) ->

          RoleMapping.create
            principalType: RoleMapping.USER,
            principalId: photographers[2].id
            roleId: roles[2].id

          , (err, principal) ->
            done err
      
      ], (err, results) ->
        
        unless err
          console.log 'Create links success'
          process.exit 0


      
