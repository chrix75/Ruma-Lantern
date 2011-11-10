
<%@ page import="org.rumal.bo.Compagny" contentType="text/html;charset=UTF-8" %>
<html>
  <head>
  	
	<g:render template="/header" model="[title: 'Add an application']"/>  	
  	<g:render template="/functions"></g:render>
  	
  	<title>Edit an application</title>
  	
  </head>
  
  <body>
  <div class="container main">
	  <g:applyLayout name="pagetitle">Edit Application</g:applyLayout>
	  
	  <g:if test="${flash.message}">
	  <g:applyLayout name="errorbanner">
	  <g:message code="${flash.message}"/>
	  </g:applyLayout>	  	
	  </g:if>
	  
	  <g:render template="/application/applicationForm" model="[Company : Compagny, application : application, actionName: 'edit']"/>
	  
  </div>
  </body>
</html>