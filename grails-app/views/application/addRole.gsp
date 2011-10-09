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
  	 
  	
  	<title>Define a new role for an application</title>
  	
  	<g:render template="/functions"></g:render>
  	
  	<g:javascript>
  	
		$(document).ready(function() {
			$('#cie').bind('change', selectedCie);
			$('#application').bind('change', selectedApp);
			
			selectOptionById('cie', "0");
			selectedCie();
			selectedApp();
		});
  	</g:javascript>
  </head>
  
  <body>
  <div class="container main">
	  <h1>Define Role</h1>
	  
	  <div class="span-15 last prepend-5">
		  <g:form action="addRole">
		      <g:hiddenField name="validate" value="true"/>
		      <p><label>Company:</label><g:select id="cie" from="${Compagny.list()}" optionKey="id" optionValue="name" name="cieId"/></p>
		      <p>
		      	<label>Application:</label>
				<select id="application" name="appId" >
				</select>
		      </p>
		      
		      <p><label>Role's name:</label><g:textField name="name"/></p>
		      <p><label>Description:</label><g:textArea name="description" cols="20" rows="5"/></p>
		      
		      <div id="permissionsList"></div>
		      
		      <g:actionSubmit value="Add" action="addRole"/>
		  </g:form>
	  </div>
	  
	  <div id="rolesTable" class="itemsTable span-20 append-2 prepend-2"></div>
	  
  </div>
  </body>
</html>
