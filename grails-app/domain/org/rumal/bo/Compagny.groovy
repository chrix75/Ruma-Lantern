package org.rumal.bo

class Compagny {

    String name
    String siret
    String zipcode

    static hasMany = [ applications : Application, employees : Employee ]


    static constraints = {
        name(nullable: false, blank: false, unique: true)
        siret(nullable: true, blank: true, validator: { siret, cie -> siret ==~ /\d+/  || !siret})
        zipcode(nullable: true, blank: true, validator: { zipcode, cie -> zipcode ==~ /\d+/ || !zipcode})
    }

    Boolean hasAlreadyApplication(String name) {
        applications.find { it.name == name } != null
    }

}
