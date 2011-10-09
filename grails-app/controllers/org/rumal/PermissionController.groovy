package org.rumal

import org.rumal.bo.Application;
import org.rumal.bo.Compagny;
import org.rumal.bo.Component;
import grails.converters.JSON;

class PermissionController {
	
	def applicationComponentsService

    def index() {
		redirect(action: 'add')
	}
	
	def loadComponentsByApp() {
		def appId = params.id
		Application a = Application.findById(appId as Long)
		
		def components = a.components as List
		render(components as JSON)
	}

	
	def add() {

        if (params.validate) {
            log.info("Add permission with params $params")

			Component component = Component.get(params.component as Long)
			assert component
			
            applicationComponentsService.addPermission(component, [name: params.name, description: params.description])

            redirect(action: 'list')

        }
	}
	
	
	def list() {
		[companies: Compagny.list()]
	}

}
