package org.rumal.svc

import org.rumal.bo.Employee;
import org.rumal.bo.Compagny;
import org.rumal.bo.Application;
import org.rumal.results.ValidationStatus;

class ValidationService {
	static final Integer VALIDATE_ENTITY_OK = 0
	static final Integer VALIDATE_ENTITY_FAILED = 100
	static final Integer VALIDATE_ENTITY_MULTIPLES = 200
	static final Integer INVALID_PARAMETER = 1000
	
	
	/**
	 * Generic method which tests if an entity is valid and can be added to the owner.
	 * 
	 * @param entity Entity to be tested.
	 * @param owner The owner of the entity. If owner is set to null then, tests about this owner are disabled.
	 * @return The status of the validation.
	 */
	def validateEntity(owner, entity, properties = null) {
		
		def validation
		if (properties) {
			validation = entity.validate(properties)
		} else {
			validation = entity.validate()
		}
		
		if (!validation) {
			return ValidationService.VALIDATE_ENTITY_FAILED
		} else {
			if (owner?.metaClass?.respondsTo(owner, 'hasAlreadyItem')) {
				if (owner.hasAlreadyItem(entity)) {
					return ValidationService.VALIDATE_ENTITY_MULTIPLES
				}
			}
		}
		
		return ValidationService.VALIDATE_ENTITY_OK
	}
	
	def addCompany(params) {
		def result = new Expando()
		result.status = ValidationService.INVALID_PARAMETER
		
		result.entity = new Compagny(params)
		result.status = validateEntity(null, result.entity)
		if (result.status == ValidationService.VALIDATE_ENTITY_OK) {
			result.entity.save()
		}
		
		return result
	}
	
	def editCompany(params) {
		def result = new Expando()
		result.status = ValidationService.INVALID_PARAMETER
		
		result.entity = new Compagny(params)
		result.status = validateEntity(null, result.entity)
		if (result.status == ValidationService.VALIDATE_ENTITY_OK) {
			Compagny c = Compagny.get(params.cieId as Long)
			c.properties = result.entity.properties
			c.save()
		} else {
			result.entity.id = params.id as Long
		}
		
		return result
	}
	
	def addApplication(params, Long companyId) {
		def result = new Expando()
		result.status = ValidationService.INVALID_PARAMETER
		
		Compagny company = Compagny.get(companyId)
		if (company) {
			result.entity = new Application(params)
			result.entity.cie = company
			
			result.status = validateEntity(company, result.entity)			
			if (result.status == ValidationService.VALIDATE_ENTITY_OK) {
				company.addToApplications(result.entity).save()
			}
		}

		return result
	}
	
	def changeApplicationFromCompany(Application a, Compagny c, newProperties) {
		a.company.removeFromApplications(a).save()
		a.properties = newProperties
		c.addToApplications(a).save()
	}

	
	def editApplication(params, Long companyId) {
		def result = new Expando()
		result.status = ValidationService.INVALID_PARAMETER
		
		Compagny company = Compagny.get(companyId)
		Application a = Application.get(params.id) 
		if (a && company) {
			result.entity = new Application(params)
			result.entity.cie = company
			
			def checkCompany = (a.name != result.entity.name ? company : null)
			
			result.status = validateEntity(checkCompany, result.entity)
			if (result.status == ValidationService.VALIDATE_ENTITY_OK) {
				
				if (a.cie != company) {
					changeApplicationFromCompany(a,company, result.entity.properties)
				} else {
					a.properties = result.entity.properties
				}

				result.entity = a
			}
		}
		
		return result
	}

	
	def addEmployee(params, Long companyId) {
		def result = new Expando()
		result.status = ValidationService.INVALID_PARAMETER
		
		Compagny company = Compagny.get(companyId)
		if (company) {
			result.entity = new Employee(params)
			result.entity.company = company
			result.status = validateEntity(company, result.entity, ['firstName', 'lastName', 'email'])
			if (result.status == ValidationService.VALIDATE_ENTITY_OK) {
				company.addToEmployees(result.entity).save()
			}
		}
		
		return result
	} 
	
	def changeEmployeeFromCompany(Employee e, Compagny c, newProperties) {
		e.company.removeFromEmployees(e).save()
		e.properties = newProperties
		c.addToEmployees(e).save()
	}
	
	def editEmployee(params, Long companyId) {
		def result = new Expando()
		result.status = ValidationService.INVALID_PARAMETER
		
		Compagny company = Compagny.get(companyId)
		Employee e = Employee.get(params.id) 
		if (e && company) {
			result.entity = new Employee(params)
			result.entity.company = company
			
			def checkedProperties = ['firstName', 'lastName']
			def checkCompany = null
			if (e.email != result.entity.email) {
				checkedProperties << 'email'
				checkCompany = company
			} 
			
			
			result.status = validateEntity(checkCompany, result.entity, checkedProperties)
			if (result.status == ValidationService.VALIDATE_ENTITY_OK) {
				
				if (e.company != company) {
					changeEmployeeFromCompany(e,company, result.entity.properties)
				} else {
					e.properties = result.entity.properties
				}

				result.entity = e
			}
		}
		
		return result
	}
	
}
