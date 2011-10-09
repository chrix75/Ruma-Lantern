<%--
  Created by IntelliJ IDEA.
  User: darkchris
  Date: 8/16/11
  Time: 10:31 PM
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
  <head>
  	
	 <link rel="stylesheet" href="${resource(dir:'css/blueprint', file:'screen.css')}" type="text/css" media="screen, projection">
	 <link rel="stylesheet" href="${resource(dir:'css/blueprint', file:'print.css')}" type="text/css" media="print"> 
	 <!--[if lt IE 8]>
	   <link rel="stylesheet" href="${resource(dir:'css/blueprint', file:'ie.css')}" type="text/css" media="screen, projection">
	 <![endif]-->
  	
  	 <link rel="stylesheet" href="${resource(dir:'css', file:'rumal.css')}" type="text/css" media="screen, projection">
  	
	 <title>Add a new company</title>
  </head>
  
  <body>
  
  <div class="container main">
  
	  <h1>Add Company</h1>
	  
	  <h2>Fill form below</h2>
	  
	  <div class="span-15 last prepend-5">
	  	  
		  <g:form action="add">
		      <g:hiddenField name="validate" value="true"/>
		      <p>
		      	<label>Company name:</label><g:textField name="name"/>
		      </p>
		      
		      <p>
		      	<label>SIRET:</label><g:textField name="siret"/>
		      </p>
		      
		      <p>
		      	<label>Zip Code:</label><g:textField name="zipcode"/>
		      </p>
		      
  	      	  <g:submitButton name="addCompany" value="Add"/>
		
		  </g:form>
	  </div>
	  
	  <div class="span-20 prepend-2 append-2 last itemsTable">
	  	<h2>Current compagnies list</h2>
	  	
	  	<table>
	  		<thead>
	  			<tr>
	  				<th class="idColumn">ID</th>
	  				<th class="nameColumn">Compagny's name</th>
  				</tr>
	  		</thead>
	  		
	  		<g:each in="${companies}">
	  			<tr>
	  				<td>${it.id}</td>
	  				<td>${it.name}</td>
	  			</tr>
	  		</g:each>
	  	</table>
	  	
	  </div>
  </div>
  </body>
</html>