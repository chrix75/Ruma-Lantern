<%--
  Created by IntelliJ IDEA.
  User: darkchris
  Date: 8/17/11
  Time: 8:15 AM
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
  <head><title>Simple GSP page</title></head>
  <body>
  <g:each in="${companies}" var="cie">
      <p>ID CIE: ${cie.id}</p>
      <p>Name CIE: ${cie.name}</p>
      <p># applications: ${cie.applications.size()}</p>

      <g:each in="${cie.applications}" var="app">
          <p>ID: ${app.id}</p>
          <p>Name: ${app.name}</p>
      </g:each>
  </g:each>

  <g:link controller="compagny" action="index">Index</g:link>

  </body>
</html>