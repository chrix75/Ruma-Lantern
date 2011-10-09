<%--
  Created by IntelliJ IDEA.
  User: darkchris
  Date: 8/16/11
  Time: 10:21 PM
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
  <head><title>Simple GSP page</title></head>
  <body>
  Your actions:

  <ul>
  <li><g:link action="add">Add a new company</g:link></li>
  <li><g:link action="addEmployee">Add new employee to a company</g:link></li>
  <li><g:link controller="application" action="add">Add a new application to a company</g:link></li>
  <li><g:link controller="application" action="addRole">Define a role to an application</g:link></li>
  <li><g:link controller="application" action="addUser">Define an user to an application</g:link></li>
  <li><g:link controller="component" action="add">Add a new component to an application</g:link></li>
  <li><g:link controller="permission" action="add">Add new permissions to a component</g:link></li>
  </ul>

  </body>
</html>