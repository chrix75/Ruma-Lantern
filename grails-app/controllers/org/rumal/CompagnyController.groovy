package org.rumal

import grails.converters.JSON;
import groovy.xml.MarkupBuilder;

import org.rumal.bo.Compagny
import org.rumal.bo.Employee;
import org.rumal.lists.AjaxListBuilder;

class CompagnyController {

    // menu page for applications management
    def index() {  }
	
	
	def loadCompanyEmployees() {
		Compagny cie = Compagny.get(params.id as Long)

		render (cie.employees as JSON)
	}


    // adds a new company to rights management system
    def add() {

        if (params.validate) {
            log.info("New company with params $params")
            // this action is called to add a new company
            Compagny cie = new Compagny(params)
            if (cie.validate()) {
                cie.save()
                log.info("Company ${cie.name} added")
                redirect(action: 'add')
            } else {
                log.error("Company ${cie.name} hasn't been added")
            }
        }  else {
            log.info("Add company form")
			return [companies: Compagny.list()]
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
			
			Employee emp = new Employee(params)
			if (emp.validate()) {
				Compagny cie = Compagny.get(params.cieId as Long)
				cie?.addToEmployees emp
				log.info("Employee ${emp.name} added to company ${cie.name}")
				redirect(action: 'addEmployee', params: [cieId:cie.id as String])
			} else {
				log.error("Employee ${emp.name} hasn't been added")
				return [employee: emp]
			}
		} else {
			def givenId = params.cieId
			return [params: [cieId: givenId ?: 0]]
		}
	}
}
