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
  	
  	<title>Define a new role for an application</title>
  	
  	<g:render template="/functions"></g:render>
  	
  	<g:javascript>
		var company;
		var application;
		var rolesTable;
		
		function updateApplicationsOptions(id, node) {
			${remoteFunction(controller: 'component', action: 'loadCompagnyApp2', params: "'id=' + id + '&updaterId=1'", onSuccess: "arguments[arguments.length] = node ; onOptionsLoaded(arguments)", onFailure: "error(arguments)")}
		}
		
  		function updateRolesList(id, node) {
			${remoteFunction(controller: 'application', action: 'fetchRoles', params: "'id=' + id + '&updaterId=1'", onSuccess: "arguments[arguments.length] = node ; onNodesLoaded(arguments)", onFailure: "error(arguments)")}
			${remoteFunction(controller: "application", action: "retrievePermissionsByComponent", params: "'id=' + id", onSuccess: "onSuccessRetrievePermissionsByComponents(arguments)", onFailure: "error(arguments)")}
  		}    	
		
  	
		$(document).ready(function() {
	  		company = RumalRoot("cie");
	  		application = company.addSelectChild("application", updateApplicationsOptions);
	  		application.setKeys({optionKey: "id", optionValue: "name" });
	  		rolesTable = application.addTableChild("rolesTable", updateRolesList, "${createLink(action:'editRole')}");
	  		rolesTable.setHeader([ {name: "ID", prop: "id", htmlClass: "idColumn"}, {name: "Name", prop: "name", htmlClass: "nameColumn"}]);
	  		
	  		nodesDict = { cie: company, application: application };
	  		
	  		$("#cie").bind("change", nodeChanged);
	  		$("#application").bind("change", nodeChanged);		
	  		
	  		$("#cie").trigger("change");
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
