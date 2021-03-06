package org.rumal.svc

import org.rumal.bo.Application
import org.rumal.bo.Component
import org.rumal.exceptions.RumalException
import org.rumal.bo.Compagny
import org.rumal.bo.Permission
import org.rumal.bo.Privilege
import org.rumal.bo.Role
import org.rumal.bo.User
import org.rumal.bo.Employee

/**
 * Offers some services for component's management.
 */
class ApplicationComponentsService {

    static transactional = true

    /**
     * Adds an application to the compagny.
     *
     * @param cie The compagny where application is added.
     * @param application Application's information.
     * @return The new application.
     * @throws RumalException Raises if an application with the same name is already inside the application.
     */
    def addApplication(Compagny cie, application) {

        if (!cie.hasAlreadyApplication(application.name)) {
            Application a = new Application(application)
			a.cie = cie
            if (a.validate()) {
                cie.addToApplications(a).save()

                log.info("Application ${a.name} added")
            } else {                
                log.error("Application ${a.name} can not be added")
            }

            
        } else {
            throw new RumalException("Application ${application.name} already exists inside compagny ${cie.name}",RumalException.APPLICATION_ALREADY_EXISTS)
        }
    }

    Application addApplication(Long cieId, application) throws RumalException {
        assert cieId
        Compagny cie = Compagny.get(cieId)
        assert cie

        addApplication(cie, application)
    }

    /**
     * Adds a new component to application. 2 components with the same name can not be inside an application.
     *
     * @param app Application
     * @param name Component's name
     * @param description Component's description
     * @return The added component.
     * @throws RumalException Raises if a component with the name is already inside the application.
     */
    Component addComponent(Application app, String name, String description, List permissions = null) throws RumalException {
        if (!app.hasAlreadyComponent(name)) {
            Component c = new Component(name: name, description: description)
            app.addToComponents(c)

            permissions?.each { p ->
                addPermission(c, p)
            }

            return c

        } else {
            throw new RumalException("Component $name already exists inside application ${app.name}",RumalException.COMPONENT_ALREADY_EXISTS)
        }
    }

    /**
     * Adds a permission to a component. This method checks if this permission already exists in the component.
     * @param component
     * @param permission
     * @return The added permission.
     * @throws RumalException Raises if the permission already exists in the component.
     */
    Permission addPermission(Component component, permission) throws RumalException {
        if (component.hasAlreadyPermission(permission.name)) {
            throw new RumalException("Permission ${permission.name} already exists inside component ${component.name}",RumalException.PERMISSION_ALREADY_EXISTS)
        }

        component.addToPermissions(permission)

        return permission
    }
	
	/**
	 * Adds a role to an application.
	 * @param app Application where role is added.
	 * @param name Role's name
	 * @param description Role's description
	 * @param permissionIdents List of permissions' id are added to new role.
	 * @return Instance of new role.
	 */
	Role addRole(Application app, String name, String description, permissionIdents)  throws RumalException {
		if (app.hasAlreadyRole(name)) {
			throw new RumalException("Role ${name} already exists for application ${app.name}",RumalException.ROLE_ALREADY_EXISTS)
		}
		
		Role role = new Role(name: name, description: description)
		permissionIdents.each {
			role.addToPermissions(Permission.get(it as Long))
		}
		
		app.addToRoles role
		
		return role
	}
	
	/**
	 * Adds an user to an employee and links this user to an application
	 * @param e Employee
	 * @param a Application
	 * @param userInfo Informations about new user
	 * @return Created user
	 */
	User addUser(Employee e, Application a, userInfo) {
		
		User user= new User(userInfo)
		e.addToUsers(user)
		a.addToUsers(user)
		
		return user
	}
	
	/**
	 * Removes an application from a company and manages users' deletion
	 * 
	 * @param c Company
	 * @param a Application
	 * @return
	 */
	def removeApplication(Compagny c, Application a) {
		a.users.collect{it}.each { it.delete() }
		c.removeFromApplications a
	}
	
	def findUsersForApplicationAndEmployee(Application a, Employee e) {
		def appUsers = a.users
		e.users.findAll { empUser -> appUsers.find { appUser -> appUser == empUser  } }
	}
	
	


}
