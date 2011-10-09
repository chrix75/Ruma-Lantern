package org.rumal.bo

class Permission {

    String name
    String description

    static constraints = {
        name(nullable: false, blank: false)
        description(nullable: false, blank: false)
    }

    static belongsTo = [ component : Component ]
}
