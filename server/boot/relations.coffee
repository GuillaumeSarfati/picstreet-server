module.exports = (server) ->
	
	Photographer = server.models.Photographer
	
	Role = server.models.Role
	RoleMapping = server.models.RoleMapping

	RoleMapping.belongsTo(Photographer,{foreignKey: 'principalId', as: 'principal'});
	RoleMapping.belongsTo(Role,{foreignKey: 'roleId', as: 'role'});
	 
	Photographer.hasMany(Role, {through: RoleMapping, foreignKey: 'principalId', as: 'roles'});
	Role.hasMany(Photographer, {through: RoleMapping, foreignKey: 'roleId', as: 'principals'});
	