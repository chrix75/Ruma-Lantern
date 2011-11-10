package org.rumal

import org.rumal.bo.Application;
import org.rumal.bo.Compagny
import org.rumal.bo.Employee;
import org.rumal.bo.Permission;
import org.rumal.bo.Role;
import org.rumal.bo.User;
import org.rumal.exceptions.RumalException;
import org.rumal.lists.AjaxListBuilder;
import org.rumal.svc.ValidationService;

import grails.converters.JSON;
import groovy.xml.MarkupBuilder;

class ApplicationController {

    def applicationComponentsService
	def validationService
	
	def fetchComponents() {
		def appId = params.id
		if (appId?.isNumber()) {
			Application application = Application.get(appId as Long)
			render(application.components as JSON)
		} else {
		render ([] as JSON)
		}
	}
	

	
	def fetchUsers() {
		if (params?.applicationId?.isNumber() && params?.employeeId?.isNumber()) {
			Employee employee = Employee.get(params.employeeId as Long)
			Application app = Application.get(params.applicationId as Long)
			render (applicationComponentsService.findUsersForApplicationAndEmployee(app, employee) as JSON)
		} else {
			render ([] as JSON)
		}
	}

	def fetchRoles() {
		if (params?.id?.isNumber()) {
			Application application = Application.get(params.id as Long)
			render (application.roles as JSON)
		} else {
			render ([] as JSON)
		}
	}
	
	def retrievePermissionsByRole() {

		Role role = Role.get(params.id as Long)
		
		// get application thanks to role
		def permissionsByComponent = retrievePermissionsByApplication(role.application, role.permissions)
		
		render (permissionsByComponent as JSON)
	}
	
	private def retrievePermissionsByApplication(Application application, selectedPermissions = null) {
		def componentsList = []
		application?.components?.each { comp ->
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
		if (params?.id?.isNumber()) {
			render (retrievePermissionsByApplication(Application.get(params.id as Long)) as JSON)
		} else {
			render([] as JSON)
		}
	}


    def index() {
        redirect(action: 'add')
    }

    def add() {
        if (params.validate) {
            log.info("Add application with params $params")
			
			def result = validationService.addApplication(params, params.cieId as Long)
			
			if (result.status == ValidationService.VALIDATE_ENTITY_OK) {
				redirect(action: 'add')
			} else if (result.status == ValidationService.VALIDATE_ENTITY_MULTIPLES) {
				flash.message = 'org.rumal.bo.Application.unique'
			}

			return [application: [cieId: params.cieId, name: params.name, description: params.description]]
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
		if (params.validate) {
			def result = validationService.editApplication(params, params.cieId as Long)
			
			if (result.status == ValidationService.VALIDATE_ENTITY_OK) {
				log.info("Update data for application ${result.entity.name})")
				redirect(action:'add')
			} else {
				return [application: result.entity]
			}
			
		} else {
			return [application: Application.get(params.id)]
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
			Application application = Application.get(params.application)
			
			log.info("New user for application ${application.name} belonging to employee ${emp.name} with params $params")
			
			applicationComponentsService.addUser(emp, application, params)
		}
		
	}
}
