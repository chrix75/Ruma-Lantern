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
	 <script type="text/javascript" src="${resource(dir:'js', file:'RumalHTMLItem.js')}"></script>
  	 
  	
  	<title>Add an user to a company</title>
  	
  	<g:render template="/functions"></g:render>
  	
  	<g:javascript>
  		var employeesTable;
  		var companies;
  		
		
  		function updateEmployeesList(id, node) {
			${remoteFunction(controller: 'compagny', action: 'loadCompanyEmployees', params: "'id=' + id + '&updaterId=1'", onSuccess: "arguments[arguments.length] = node ; onNodesLoaded(arguments)", onFailure: "error(arguments)")}
  		}    	
  	
		$(document).ready(function() {
	  		companies = RumalRoot("cie");
	  		employeesTable = companies.addTableChild("employeesTable", updateEmployeesList, "${createLink(action:'editEmployee')}");
	  		employeesTable.setHeader([ {name: "ID", prop: "id", htmlClass: "idColumn"}, {name: "First Name", prop: "firstName", htmlClass: "nameColumn"}]);
	  		
	  		nodesDict = { cie: companies };
	  		
	  		$("#cie").bind("change", nodeChanged);		
	  		
	  		$("#cie").trigger("change");
		});
  	</g:javascript>
  </head>
  
  <body>
  <div class="container main">
	  <h1>Add Employee</h1>
	  
	  <div class="span-15 last prepend-5">
		  <g:form action="addEmployee">
		      <g:hiddenField name="validate" value="true"/>
		      <p><label>Company:</label><g:select id="cie" from="${Compagny.list()}" optionKey="id" optionValue="name" name="cieId"/></p>
		      
		      <p><label>Firstname:</label><g:textField name="firstName" value="${employee?.firstName ?: ''}"/></p>
		      <!-- Error message for above field [START]-->
		      <g:hasErrors bean="${employee}" field="firstName">
	  			<g:eachError bean="${employee}" field="firstName">
    				<p class="inputError"><g:message error="${it}"/></p>
				</g:eachError>
		      </g:hasErrors>
		      <!-- Error message for above field [END]-->
		      
		      <p><label>Lastname:</label><g:textField name="lastName" value="${employee?.lastName ?: ''}"/></p>
		      <!-- Error message for above field [START]-->
		      <g:hasErrors bean="${employee}" field="lastName">
	  			<g:eachError bean="${employee}" field="lastName">
    				<p class="inputError"><g:message error="${it}"/></p>
				</g:eachError>
		      </g:hasErrors>
		      <!-- Error message for above field [END]-->
		      
		      <p><label>Email:</label><g:textField name="email" value="${employee?.email ?: ''}"/></p>
			  <!-- Error message for above field [START]-->
		      <g:hasErrors bean="${employee}" field="email">
	  			<g:eachError bean="${employee}" field="email">
    				<p class="inputError"><g:message error="${it}"/></p>
				</g:eachError>
		      </g:hasErrors>
		      <!-- Error message for above field [END]-->
		      
			  	
		      <g:actionSubmit value="AddEmployee"/>
		  </g:form>
	  </div>
	  
	  <div id="employeesTable" class="itemsTable span-20 append-2 prepend-2"></div>
	  
  </div>
  </body>
</html>