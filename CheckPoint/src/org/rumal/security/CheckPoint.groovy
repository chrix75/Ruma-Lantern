package org.rumal.security

/**
 * Created by IntelliJ IDEA.
 * User: darkchris
 * Date: 8/11/11
 * Time: 9:09 PM
 * To change this template use File | Settings | File Templates.
 */
class CheckPoint {
    final static Integer APPLICATION_UNDEFINED = 100
    final static Integer ACTION_UNDEFINED = 200
    final static Integer COMPONENT_UNDEFINED = 300
    final static Integer FORBIDDEN_ACTION = 1000
    final static Integer UNKNOWN_USER = 1100

    static String GLOBAL_APPLICATION_NAME

    String applicationName
    String componentName

    /**
     * Creates a new CheckPoint.
     *
     * @param applicationName The application's name.
     * @param componentName The component's name whose CheckPoint checks security.
     * @return A new instance of CheckPoint.
     */
    static CheckPoint newCheckPoint(String applicationName, String componentName) {
        new CheckPoint(applicationName: applicationName, componentName: componentName)
    }

    /**
     * Creates a new CheckPoint whose application's name is set with the global application's name.
     *
     * @param componentName The component's name whose CheckPoint checks security.
     * @return  A new instance of CheckPoint.
     * @throws CheckPointException Raises if no global application's name is set.
     */
    static CheckPoint newCheckPoint(String componentName) throws CheckPointException {
        if (!GLOBAL_APPLICATION_NAME) {
            throw new CheckPointException('None application name is defined', APPLICATION_UNDEFINED)
        }

        new CheckPoint(applicationName: GLOBAL_APPLICATION_NAME, componentName: componentName)
    }

    /**
     * Checks if an user can do an action.
     *
     * @param actionName Action's name for checking.
     * @param userId User's ID known by Rumal
     * @return
     * @throws CheckPointException Raises if the user can't do the given action.
     */
    def check(String actionName, Long userId) throws CheckPointException {
        if (!actionName) {
            throw new CheckPointException('No action\'s name is set', ACTION_UNDEFINED)
        }

        if (!applicationName) {
            throw new CheckPointException('No application\'s name is defined', APPLICATION_UNDEFINED)
        }

        if (!componentName) {
            throw new CheckPointException('No component\'s name is defined', COMPONENT_UNDEFINED)
        }

        //TODO: Write the implementation
        if (userId == 2 && actionName == 'COUNT') {
            throw new CheckPointException('This action is forbidden for user', FORBIDDEN_ACTION)
        }

        if (userId == 3) {
            throw new CheckPointException('Unknown user', UNKNOWN_USER)
        }
    }

}
