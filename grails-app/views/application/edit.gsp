
<%@ page import="org.rumal.bo.Compagny" contentType="text/html;charset=UTF-8" %>
<html>
  <head>
  	
	 <link rel="stylesheet" href="${resource(dir:'css/blueprint', file:'screen.css')}" type="text/css" media="screen, projection">
	 <link rel="stylesheet" href="${resource(dir:'css/blueprint', file:'print.css')}" type="text/css" media="print"> 
	 <!--[if lt IE 8]>
	   <link rel="stylesheet" href="${resource(dir:'css/blueprint', file:'ie.css')}" type="text/css" media="screen, projection">
	 <![endif]-->
  	
  	 <link rel="stylesheet" href="${resource(dir:'css', file:'rumal.css')}" type="text/css" media="screen, projection">
  	 
  	 <g:javascript library="jquery" />
	 <r:layoutResources />
  	 
  	
  	<title>Edit an application</title>
  	
  	<g:render template="/functions"></g:render>
  	
  </head>
  
  <body>
  <div class="container main">
	  <h1>Edit Application</h1>
	  
	  <div class="span-15 last prepend-5">
		  <g:form action="edit">
		      <g:hiddenField name="validate" value="true"/>
		      <g:hiddenField name="id" value="${id}"/>
		      <p><label>App's name:</label><g:textField name="name" value="${name}"/></p>
		      <p><label>Description:</label><g:textArea name="description" cols="20" rows="5" value="${description}"/></p>
		
		      <g:actionSubmit value="Edit"/>
		  </g:form>
	  </div>
	  
  </div>
  </body>
</html>