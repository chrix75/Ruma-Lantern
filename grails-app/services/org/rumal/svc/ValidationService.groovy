package org.rumal.svc

import org.rumal.bo.Employee;
import org.rumal.bo.Compagny;
import org.rumal.results.ValidationStatus;

class ValidationService {
	
	private alreadyInCompany(Employee e, Compagny c) {
		c.employees.find {
			it.email == e.email
		}
	}
	

    ValidationStatus validateEmployee(Employee e, Compagny c, searchInCompany = true) {
		def status = new ValidationStatus(error: true)
		
		if (e.validate()) {
			if (searchInCompany && alreadyInCompany(e, c)) {
				status.message = "org.rumal.bo.Employee.already.in.company"
			} else {
				status.error = false
				if (e.id) {
					e.save()	
				} else {
					c.addToEmployees(e)
				}
			}
		} 

		return status
    }
}
