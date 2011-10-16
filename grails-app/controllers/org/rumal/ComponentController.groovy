package org.rumal

import grails.converters.JSON;

import org.codehaus.groovy.grails.web.json.JSONArray;
import org.rumal.bo.Application;
import org.rumal.bo.Compagny;
import org.rumal.bo.Component;
import org.rumal.lists.AjaxListBuilder;

class ComponentController {
	
	def applicationComponentsService

    def index() { redirect(action: 'add')}
	
	def fetchPermissions() {
		if (params?.id?.isNumber()) {
			render(Component.get(params.id as Long).permissions as JSON)
		} else {
			render([] as JSON)
		}
	
	}


	def loadCompagnyApp() {
		def cieId = params.id
		Compagny c = Compagny.findById(cieId as Long)
		
		def app = c.applications as List
		render(app as JSON)	
	}
	

	/**
	 * Ajax method which returns all applications of a company.
	 * This method renders a map into a JSON object. 
	 * 
	 * This method waits for 2 parameters: id and masterId. 
	 * id is the company's id.
	 * updaterId is the client side compoment which is the source of this call.
	 *  
	 * @return 
	 */
	def loadCompagnyApp2() {
		def cieId = params.id
		if (cieId?.isNumber()) {
			render([updaterId: params.updaterId, cieId: cieId, items: Compagny.findById(cieId as Long)?.applications] as JSON)
		} else {
			render([] as JSON)
		}
	}

	
    def add() {
		if (params.validate) {
			log.info("Add component to application with params $params")
			
			Application app = Application.get(params.application as Long)
			applicationComponentsService.addComponent(app, params.name, params.description)
			
			redirect(action: 'add', params: [currentApp: app.id as String, currentCie: app.cie.id as String])
		} else {
			// to select by default the first items in GSP
			def cieId = params.currentCie ?: '0'
			def appId = params.currentApp ?: '0'
			[params: [currentCie: cieId, currentApp: appId]]
		}
    }
	
	def list() {
		[companies: Compagny.list()]
	}

}
