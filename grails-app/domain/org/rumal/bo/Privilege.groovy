package org.rumal.bo

class Privilege {

    Permission permission

    static constraints = {
        permission(nullable: false)
    }

    static belongsTo = [ user : User ]
}
