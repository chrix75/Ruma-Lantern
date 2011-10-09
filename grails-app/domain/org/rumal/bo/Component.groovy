package org.rumal.bo

class Component {

    String name
    String description

    static constraints = {
        name(nullable: false, blank: false)
        description(nullable: false, blank: false)
    }

    static belongsTo = [application : Application]

    static hasMany = [ permissions : Permission ]


    Boolean hasAlreadyPermission(String name) {
        permissions.find { it.name == name } != null
    }


}
