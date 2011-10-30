package org.rumal.svc

import org.rumal.bo.Employee;
import org.rumal.bo.Compagny;

class ValidationService {
	
	private alreadyInCompany(Employee e, Compagny c) {
		c.employees.find {
			it.email == e.email
		}
	}
	

    def validateEmployee(Employee e, Compagny c) {
		if (e.validate()) {
			if (alreadyInCompany(e, c)) {
				return "org.rumal.bo.Employee.already.in.company"
			} else {
				return true
			}
		}

		return false
    }
}
