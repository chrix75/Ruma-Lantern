package org.rumal

import org.rumal.bo.Application;
import org.rumal.bo.Compagny
import org.rumal.bo.Employee;
import org.rumal.bo.Permission;
import org.rumal.bo.Role;
import org.rumal.bo.User;
import org.rumal.lists.AjaxListBuilder;

import grails.converters.JSON;
import groovy.xml.MarkupBuilder;

class ApplicationController {

    def applicationComponentsService
	
	def fetchComponents() {
		Application application = Application.get(params.id as Long)
		render AjaxListBuilder.htmlList(application.components)
	}
	
	def fetchUsers() {
		Employee employee = Employee.get(params.id as Long)
		render (employee.users as JSON)
	}

	def fetchRoles() {
		Application application = Application.get(params.id as Long)
		render (application.roles as JSON)
	}
	
	def retrievePermissionsByRole() {

		Role role = Role.get(params.id as Long)
		
		// get application thanks to role
		def permissionsByComponent = retrievePermissionsByApplication(role.application, role.permissions)
		
		render (permissionsByComponent as JSON)
	}
	
	private def retrievePermissionsByApplication(Application application, selectedPermissions = null) {
		def componentsList = []
		application.components.each { comp ->
			def componentData = [name: comp.name]
			def currentPermissions = []
			comp.permissions.each { perm ->

				if (perm in selectedPermissions) {
					currentPermissions << [name: perm.name, id: perm.id, checked: true]
				} else {
					currentPermissions << [name: perm.name, id: perm.id]
				} 
				
			}
			componentData["permissions"] = currentPermissions
			componentsList << componentData
		}
		
		return componentsList
	}
	
	def retrievePermissionsByComponent() {
		render (retrievePermissionsByApplication(Application.get(params.id as Long)) as JSON)
	}


    def index() {
        redirect(action: 'add')
    }

    def add() {
        if (params.validate) {
            log.info("Add application with params $params")
            assert params.cieId

            applicationComponentsService.addApplication(params.cieId as Long, [name: params.name, description: params.description])

            redirect(action: 'add')

        }
    }
	
	private def extractPermissionIdents(htmlPermissions) {
		if (!htmlPermissions) {
			return null
		}
		
		htmlPermissions.collect {
			it[1..-1] as Long
		}
	}
	
	private def findPermissionsByParams(params) {
		params.keySet().findAll {
			it ==~ /P[0-9]+/
		}
	}
	
	def addRole() {
		if (params.validate) {
			log.info("Add role with params $params")
			
			def selectedPermissions = findPermissionsByParams(params)
			
			log.debug("Permissions selected: $selectedPermissions")
			
			applicationComponentsService.addRole(Application.get(params.appId as Long), params.name, params.description, extractPermissionIdents(selectedPermissions))
			
		}
	}

    def list() {
        [companies: Compagny.list()]
    }
	
	def edit() {
		Application app = Application.get(params.id as Long)
		if (params.validate) {
			log.info("Update data for application ${app.name})")
			
			app.name = params.name
			app.description = params.description
			app.save()
			
			redirect(action:'add')		
			
		} else {
			return [name: app?.name, description: app?.description, id: app?.id]
		}
	}
	
	def editRole() {
		Role role = Role.get(params.id as Long)
		if (params.validate) {
			log.info("Update data for role ${role.name})")
			
			role.name = params.name
			role.description = params.description

			def selectedPermissions = findPermissionsByParams(params)
			
			log.debug("Permissions selected: $selectedPermissions")
			
			def removedRoles = role.permissions.collect { it }
			
			removedRoles.each {
				role.removeFromPermissions it
			}
			
			extractPermissionIdents(selectedPermissions).each {
				role.addToPermissions(Permission.get(it as Long))
			}
						
			role.save()
			
			redirect(action:'addRole')		
		} else {
			return [name: role?.name, description: role?.description, id: role?.id]
		}
		
	}
	
	def addUser() {
		if (params.validate) {
			Employee emp = Employee.get(params.employee)
			log.info("New user for employee ${emp.name} with params $params")
			
			User user= new User(params)
			emp.addToUsers(user)
			
		}
		
	}
}
