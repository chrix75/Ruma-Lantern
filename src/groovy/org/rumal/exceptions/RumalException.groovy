package org.rumal.exceptions

/**
 * Created by IntelliJ IDEA.
 * User: darkchris
 * Date: 8/11/11
 * Time: 10:28 PM
 * To change this template use File | Settings | File Templates.
 */
class RumalException extends Exception {

    final static Integer COMPONENT_ALREADY_EXISTS = 100
    final static Integer PERMISSION_ALREADY_EXISTS = 200
    final static Integer APPLICATION_ALREADY_EXISTS = 300
	final static Integer ROLE_ALREADY_EXISTS = 400

    Integer code
    String message

    RumalException(String message, Integer code) {
        this.code = code
        this.message = message
    }
}
