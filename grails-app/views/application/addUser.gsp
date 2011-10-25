
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
  	
  	<title>Define an user for an application</title>
  	
  	<g:render template="/functions"></g:render>
  	
  	<g:javascript>
		var company;
		var application;
		var employee;
		var usersTable;
  			
		function updateApplicationsOptions(id, node) {
			${remoteFunction(controller: 'component', action: 'loadCompagnyApp2', params: "'id=' + id + '&updaterId=1'", onSuccess: "arguments[arguments.length] = node ; onOptionsLoaded(arguments)", onFailure: "error(arguments)")}
		}
		
		function updateEmployeesOptions(id, node) {
			${remoteFunction(controller: 'compagny', action: 'loadCompanyEmployees', params: "'id=' + id + '&updaterId=1'", onSuccess: "arguments[arguments.length] = node ; onOptionsLoaded(arguments)", onFailure: "error(arguments)")}
		}
		
		function updateUsersList(id, node) {
			${remoteFunction(controller: 'application', action: 'fetchUsers', params: "'applicationId=' + id.application + '&employeeId=' + id.employee", onSuccess: "arguments[arguments.length] = node ; onNodesLoaded(arguments)", onFailure: "error(arguments)")}
		}
		
  	
		$(document).ready(function() {
	  		company = RumalRoot("cie");
	  		
	  		application = company.addSelectChild("application", updateApplicationsOptions);
	  		application.setKeys({optionKey: "id", optionValue: "name" });
	  		
	  		employee = company.addSelectChild("employee", updateEmployeesOptions);
	  		employee.setKeys({optionKey: "id", optionValue: "firstName" });
	  		
	  		usersTable = employee.addTableChild("usersTable", updateUsersList, "${createLink(action:'edit')}");
	  		usersTable.addParent(application);
	  		usersTable.setHeader([ {name: "ID", prop: "id", htmlClass: "idColumn"}, {name: "Login", prop: "login", htmlClass: "nameColumn"} ]);
	  		
	  		
	  		nodesDict = { cie: company, application: application, employee: employee };
	  		
	  		$("#cie").bind("change", nodeChanged);
	  		$("#application").bind("change", nodeChanged);
	  		$("#employee").bind("change", nodeChanged);		
	  		
	  		$("#cie").trigger("change");
		});
  	</g:javascript>
  </head>
  
  <body>
  <div class="container main">
	  <h1>Define User</h1>
	  
	  <div class="span-15 last prepend-5">
		  <g:form action="addUser">
		      <g:hiddenField name="validate" value="true"/>
		      <p><label>Company:</label><g:select id="cie" from="${Compagny.list()}" optionKey="id" optionValue="name" name="cieId"/></p>
		      <p><label>Application:</label><select id="application" name="application"></select></p>
		      <p><label>Employee:</label><select id="employee" name="employee"></select></p>
		      <p><label>Login:</label><g:textField name="login"/></p>
		      <p><label>Password:</label><g:textField name="password"/></p>
		
		      <g:actionSubmit value="Add" action="addUser"/>
		  </g:form>
	  </div>
	  
	  <div id="usersTable" class="itemsTable span-20 append-2 prepend-2"></div>
	  
  </div>
  </body>
</html>
