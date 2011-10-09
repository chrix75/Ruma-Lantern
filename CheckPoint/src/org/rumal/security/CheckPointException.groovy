package org.rumal.security

/**
 * Created by IntelliJ IDEA.
 * User: darkchris
 * Date: 8/11/11
 * Time: 9:12 PM
 * To change this template use File | Settings | File Templates.
 */
class CheckPointException extends Exception {
    Integer exceptionCode
    String message

    CheckPointException(String msg, Integer code) {
        message = msg
        exceptionCode = code
    }

    CheckPointException(String msg) {
        message = msg
        exceptionCode = -1
    }
}
