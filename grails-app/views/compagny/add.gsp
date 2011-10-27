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
   	 
 	 <g:javascript library="jquery" />
 	 <r:layoutResources />
	 <script type="text/javascript" src="${resource(dir:'js', file:'gui.js')}"></script>
  	
	 <title>Add a new company</title>
	 
	 <g:javascript>
	 	$(document).ready(function() {
	 		$("#details").bind("click", toggleDetails);
	 		$("#details img").addClass("close");
	 	});
	 	
	 </g:javascript>
  </head>
  
  <body>
  
  <div class="container main">
  
	  <h1>Add Company</h1>
	  <hr>
	  
	  <div class="span-18 last prepend-3 append-3">
	  	<div class="info">
	  	Fill the form below with company's information.<br/>
	  	<b>Note:</b> Company's name must be filled and unique.	  	
	  	</div>
	  </div>
	  
	  <div class="span-15 last prepend-5">
	  	  
		  <g:form action="add">
		      <g:hiddenField name="validate" value="true"/>
		      
		      <p>
		      	<label>Company name:</label><g:textField name="name" value="${fieldValue(bean:company, field:'name')}"/>
		      </p>
		      
		      <g:hasErrors bean="${company}" field="name">
			      <p class="inputError">
				      <g:eachError bean="${company}" field="name">
		              	<g:message error="${it}"/>
		         	  </g:eachError>
			      </p>
		      </g:hasErrors>
		      
		      <p>
		      	<label>SIRET:</label><g:textField name="siret"/>
		      </p>
		      
		      <p>
		      	<label>Zip Code:</label><g:textField name="zipcode"/>
		      </p>
		      
		      
  	      	  <g:submitButton name="addCompany" value="Add"/>
		
		  </g:form>
	  </div>
	  
	<hr>
	  
	<div id="details" class="span-20 prepend-2 append-2 last">
		<img src="${resource(dir:'images', file:'arrow.png')}">
		<span>List</span>
	</div>
	
	
	<div class="span-20 prepend-2 append-2 last itemsTable">
	  	
	  	<table>
	  		<thead>
	  			<tr>
	  				<th class="idColumn">ID</th>
	  				<th class="nameColumn">Company's name</th>
  				</tr>
	  		</thead>
	  		
	  		<tbody>
	  		<g:each in="${companies}" var="cie">
	  			<tr>
	  				<td>${cie.id}</td>
	  				<td>${cie.name}</td>
	  			</tr>
	  		</g:each>
	  		</tbody>
	  	</table>
	  	
	</div>
  </div>
  </body>
</html>