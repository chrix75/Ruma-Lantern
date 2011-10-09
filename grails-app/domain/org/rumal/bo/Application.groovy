package org.rumal.bo

class Application {
    String name
    String description

    static constraints = {
        name(nullable: false, blank: false, unique: true)
        description(nullable: false, blank: false)
    }

    static hasMany = [ components : Component, roles : Role ]

    static belongsTo = [ cie : Compagny]

    Boolean hasAlreadyComponent(String name) {
        components.find { it.name == name } != null
    }
	
	Boolean hasAlreadyRole(String name) {
		roles.find { it.name == name } != null
	}

}
