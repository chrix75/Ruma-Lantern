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
	  <h1>Company</h1>
      <p>ID CIE: ${cie.id}</p>
      <p>Name CIE: ${cie.name}</p>
      <p># applications: ${cie.applications.size()}</p>

      <g:each in="${cie.applications}" var="app">
     	  <h2>Application</h2>
          <p>ID: ${app.id}</p>
          <p>Name: ${app.name}</p>
          
          
	      <g:each in="${app.components}" var="component">
	      	  <h3>Component</h3>
	          <p>ID: ${component.id}</p>
	          <p>Name: ${component.name}</p>
          
	          <h4>Permissions</h4>
		      <g:each in="${component.permissions}" var="perms">
		          <p>ID: ${perms.id}</p>
		          <p>Name: ${perms.name}</p>
		      </g:each>
          
	      </g:each>
          
      </g:each>
  </g:each>

  <g:link controller="compagny" action="index">Index</g:link>

  </body>
</html>
