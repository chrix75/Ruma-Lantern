<%--
  Created by IntelliJ IDEA.
  User: darkchris
  Date: 8/16/11
  Time: 11:25 PM
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
  <head><title>Companies list</title></head>
  <body>
  <g:each in="${companies}">
      <p>ID: ${it.id}</p>
      <p>Name: ${it.name}</p>
  </g:each>

  <g:link action="index">Index</g:link>
  </body>
</html>