package org.rumal.bo

class User {

    String login
    String password

    static constraints = {
        login(nullable: false, blank: false, size: 3..15, unique: true)
        password(nullable: false, blank: false, size: 3..15, validator: { pwd, user -> pwd != user.login })
    }


    static hasMany = [roles: Role, privileges: Privilege]
    static belongsTo = Employee

    /**
     * Search a privilege for a permission.
     *
     * @param p The searched permission.
     * @return The privilege of the corresponding permission.
     */
    private Privilege findPrivilegeForPermission(Permission p) {
        Privilege privilege
        def permission = privileges.find {
            privilege = it
            privilege.permission == p
        }

        if (!permission) privilege = null

        return privilege
    }

    /**
     * Add a right to the user. A right is a privilege object linked with a component's permission.
     *
     * @param permission Permission
     * @return The new privilege for the given permission.
     */
    Privilege addRight(Permission permission) {
        def privilege = findPrivilegeForPermission(permission)
        if (!privilege) {
            privilege = new Privilege(permission: permission)
            addToPrivileges(privilege)
        }

        return privilege
    }

    /**
     * Remove a right of an user by a permission.
     *
     * @param permission
     *
     */
    def removeRight(Permission permission) {
        def privilege = findPrivilegeForPermission(permission)
        if (privilege) {
            removeFromPrivileges(privilege)
        }
    }


}
