package org.rumal.svc

import org.rumal.bo.Permission
import org.rumal.results.ResultChecking
import org.rumal.bo.User

class RightsCheckingService {

    /**
     * Checks if an user can process an action of a component.
     *
     * @param user The tested user.
     * @param applicationName Application's name where component is.
     * @param componentName Component's name where action is.
     * @param actionName Action's name whose we want to know if the user can do.
     * @return A ResultChecking object that gives information about user's right for the given action.
     */
    ResultChecking checkRight(User user, String applicationName, String componentName, String actionName) {
        assert user
        assert applicationName
        assert componentName
        assert actionName

        // fetches permission of the searched action
        def c = Permission.createCriteria()
        def permission = c.get {
            and {
                eq('name', actionName)

                component {
                    eq('name', componentName)

                    application {
                        eq('name', applicationName)
                    }
                }
            }
        }

        if (!permission) {
            return new ResultChecking(code: ResultChecking.CHECKING_UNKNOWN_ACTION, message: "The action $applicationName.$componentName.$actionName not found.")
        }

        // checks if the user has privilege on this permission
        def foundPrivilege = user.privileges.find {
            it.permission == permission
        }

        if (foundPrivilege) {
            return new ResultChecking(code: ResultChecking.CHECKING_AUTHORIZED_USER, message: "The user ${user.id} can do action $applicationName.$componentName.$actionName")
        }

        return new ResultChecking(code: ResultChecking.CHECKING_UNAUTHORIZED_USER, message: "The user ${user.id} can NOT do action $applicationName.$componentName.$actionName")
    }


    /**
     * Checks if an user can process an action of a component.
     *
     * @param userId ID of the tested user.
     * @param applicationName Application's name where component is.
     * @param componentName Component's name where action is.
     * @param actionName Action's name whose we want to know if the user can do.
     * @return A ResultChecking object that gives information about user's right for the given action.
     */
    ResultChecking checkRight(Long userId, String applicationName, String componentName, String actionName) {

        // checks if user exists
        User user = User.get(userId)
        if (!user) {
            return new ResultChecking(code: ResultChecking.CHECKING_UNKNOWN_USER, message: "User with ID $userId not found.")
        }

        checkRight(user, applicationName, componentName, actionName)

    }
}
