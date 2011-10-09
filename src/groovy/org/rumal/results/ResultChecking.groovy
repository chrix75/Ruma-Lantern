package org.rumal.results

/**
 * Created by IntelliJ IDEA.
 * User: darkchris
 * Date: 8/16/11
 * Time: 8:15 PM
 * To change this template use File | Settings | File Templates.
 */

/**
 * This class gives information about a rights checking.
 * The code property must be a CHECKING_XXXX variable.
 * The message property is free for developer.
 */
class ResultChecking {

    static final public Integer CHECKING_UNKNOWN_USER = 100
    static final public Integer CHECKING_UNAUTHORIZED_USER = 200
    static final public Integer CHECKING_UNKNOWN_ACTION = 300
    static final public Integer CHECKING_AUTHORIZED_USER = 400

    Integer code
    String message

    /**
     * Overrides the = operator to make easier comparison with a code value.
     *
     * @param code The tested code.
     * @return True if this ResultChecking has code equals to code parameter.
     */
    Boolean equals(Integer code) {
        if (code == null) {
            throw new NullPointerException("Code must not be NULL.")
        }

        this.code == code
    }
}
