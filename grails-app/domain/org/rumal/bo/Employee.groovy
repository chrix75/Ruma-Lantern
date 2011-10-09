package org.rumal.bo

class Employee {

    String firstName
    String lastName
    String email

    static constraints = {
        firstName(nullable: false, blank: false)
        lastName(nullable: false, blank: false)
        email(nullable: false, blank: false, email: true)
    }

    static belongsTo = Compagny

    static hasMany = [ users : User ]
	
	/**
	 * Format employee's name by using firstname and lastname properties.
	 * This method method exists because of the implementation of the htmlList method.
	 * @return String with employee's fullname.
	 */
	String getName() {
		"$firstName $lastName"
	}
}
