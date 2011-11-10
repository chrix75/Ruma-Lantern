package org.rumal

import grails.converters.JSON;
import groovy.xml.MarkupBuilder;

import org.rumal.bo.Compagny
import org.rumal.bo.Employee;
import org.rumal.lists.AjaxListBuilder;
import org.rumal.svc.ValidationService

class CompagnyController {
	
	def validationService

    // menu page for applications management
    def index() {  }
	
	def loadCompanies() {
		render (Compagny.list() as JSON)
	}
	
	def loadCompanyEmployees() {
		if (params?.id?.isNumber()) {
			Compagny cie = Compagny.get(params.id as Long)
			render (cie.employees as JSON)
		} else {
			render([] as JSON)
		}
	}


    // adds a new company to rights management system
    def add() {
        if (params.validate) {
            log.info("New company with params $params")
			def result = validationService.addCompany(params)
			
			if (result.status == ValidationService.VALIDATE_ENTITY_OK) {
                log.info("Company ${result.entity.name} added")
                redirect(action: 'add')
            } else {
                log.error("Company ${result.entity.name} hasn't been added")
				return [company: result.entity, companies: Compagny.list()]
            }
        }  else {
            log.info("Add company form")
			return [companies: Compagny.list()]
        }
		
    }
	
	def edit() {
        if (params.validate) {
            log.info("Edit company with params $params")
            // this action is called to add a new company
			
			def result = validationService.editCompany(params)
			
			if (result.status == ValidationService.VALIDATE_ENTITY_OK) {
                log.info("Company ${result.entity.name} changed")
                redirect(action: 'add')
			} else {
				return [company: result.entity, companies: Compagny.list(), actionType: 'edit']
			}
        }  else {
            log.info("Edit company form")
			return [company: Compagny.get(params.id as Long), actionType: 'edit']
        }
	}
	
	/**
	 * Ajax function which fetch all applications of a company.
	 * 
	 * @return No return, the result is rendered inside HTML div element.
	 */
	def fetchApplications() {
		if (params?.id?.isNumber()) {
			Compagny company = Compagny.get(params.id as Long)
			render (company.applications as JSON)
		} else {
			render ([] as JSON)
		}
	}
	
	/**
	 * Ajax function which fetch all current company's employees.
	 *
	 * @return No return, the result is rendered inside HTML div element.
	 */
	def fetchEmployees() {
		Compagny company = Compagny.get(params.id as Long)
		def employees = []
		company.employees.each {
			employees << [id: it.id, name: it.name]
		}
		render (employees as JSON)
	}

	// Shortcut method returns companies list.
    def list() {
        [companies: Compagny.list()]
    }
	
	// Adds an user to a company.
	def addEmployee() {
		if (params.validate) {
			log.info("New employee with params $params")
			
			def result = validationService.addEmployee(params, params.cieId as Long)
			
			if (result.status == ValidationService.VALIDATE_ENTITY_OK) {
				log.info("Employee ${result.entity.email} added to company ${result.entity.company.name}")
				flash.success = 'org.rumal.bo.Employee.adding.successful'
				redirect(action: 'addEmployee', params: [cieId:result.entity.company.id as String])
			} else {
				log.error("Employee ${result.entity} hasn't been added")
				
				if (result.status == ValidationService.VALIDATE_ENTITY_MULTIPLES) {
					flash.message = 'Ploum'
				}
				
				return [employee: result.entity]
			}
		} else {
			def givenId = params.cieId
			return [params: [cieId: givenId ?: 0]]
		}
	}
	
	def editEmployee() {
		if (params.validate) {
			log.info("Edit employee with params $params")

			def result = validationService.editEmployee(params, params.cieId as Long)
			
			if (result.status == ValidationService.VALIDATE_ENTITY_OK) {
				log.info("Employee ${result.entity.email} modified in company ${result.entity.company.name}")
				flash.success = 'org.rumal.bo.Employee.editing.successful'
				redirect(action: 'addEmployee', params: [cieId:result.entity.company.id as String])
			} else {
				log.error("Employee ${result.entity} hasn't been changed")
				
				if (result.status == ValidationService.VALIDATE_ENTITY_MULTIPLES) {
					flash.mailerror = 'org.rumal.bo.Employee.email.unique'
				}
				
				result.entity.id = params.id as Long
				return [employee: result.entity]
			}

			
		} else {
			return [employee: Employee.get(params.id as Long)] 
		}
	}
}
