package org.rumal.bo

/**
 * A role is a privileges set-box for an application.
 * @author darkchrix
 *
 */
class Role {

    String name
	String description

    static constraints = {
        name(nullable: false, blank: false)
		description(nullable: true, blank: true)
    }
	
	static hasMany = [ permissions : Permission ]
	static belongsTo = [application : Application]
}
