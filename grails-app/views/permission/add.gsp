<%--
  Created by IntelliJ IDEA.
  User: darkchris
  Date: 8/17/11
  Time: 9:04 PM
  To change this template use File | Settings | File Templates.
--%>

<%@page import="com.sun.net.httpserver.Authenticator.Success"%>
<%@ page import="org.rumal.bo.Compagny"
	contentType="text/html;charset=UTF-8"%>
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
	 
	<title>Add a permission to component</title>
	
	<script type="text/javascript" src="${resource(dir: "js", file: "utils.js")}"></script>
	<script type="text/javascript" src="${resource(dir: "js", file: "gui.js")}"></script>

	<g:render template="/functions"></g:render>

	<g:javascript>
		var company;
		var application;
		var component;
		var permissionsTable;
		
		function updateApplicationsOptions(id, node) {
			${remoteFunction(controller: 'component', action: 'loadCompagnyApp2', params: "'id=' + id + '&updaterId=1'", onSuccess: "arguments[arguments.length] = node ; onOptionsLoaded(arguments)", onFailure: "error(arguments)")}
		}
		
		function updateEmployeesOptions(id, node) {
			${remoteFunction(controller: 'application', action: 'fetchComponents', params: "'id=' + id + '&updaterId=1'", onSuccess: "arguments[arguments.length] = node ; onOptionsLoaded(arguments)", onFailure: "error(arguments)")}
		}
		
		function updatePermissionsList(id, node) {
			${remoteFunction(controller: 'component', action: 'fetchPermissions', params: "'id=' + id + '&updaterId=1'", onSuccess: "arguments[arguments.length] = node ; onNodesLoaded(arguments)", onFailure: "error(arguments)")}
		}
		
		function updateComponentsOptions(id, node) {
			${remoteFunction(controller: 'application', action: 'fetchComponents', params: "'id=' + id + '&updaterId=1'", onSuccess: "arguments[arguments.length] = node ; onOptionsLoaded(arguments)", onFailure: "error(arguments)")}
		}

		
		$(document).ready(function(e) {
	  		company = RumalRoot("cie");
	  		
	  		application = company.addSelectChild("application", updateApplicationsOptions);
	  		application.setKeys({optionKey: "id", optionValue: "name" });
	  		
	  		component = application.addSelectChild("component", updateComponentsOptions);
	  		component.setKeys({optionKey: "id", optionValue: "name" });
	  		
	  		permissionsTable = component.addTableChild("permissionsTable", updatePermissionsList, "${createLink(action:'edit')}");
	  		permissionsTable.setHeader([ {name: "ID", prop: "id", htmlClass: "idColumn"}, {name: "Name", prop: "name", htmlClass: "nameColumn"}]);
	  		
	  		nodesDict = { cie: company, application: application, component: component };
	  		
	  		$("#cie").bind("change", nodeChanged);
	  		$("#application").bind("change", nodeChanged);
	  		$("#component").bind("change", nodeChanged);		
	  		
	  		$("#cie").trigger("change");
		
		});
    </g:javascript>
</head>

<body>
	<div class="container main">
		<h1>Add Permission</h1>
		
		<div class="span-15 last prepend-5">
			<g:form action="add">
				<g:hiddenField name="validate" value="true"/>
				<label>Companies:</label>
				<g:select from="${Compagny.list()}" name="cie" id="cie"
					optionKey="id" optionValue="name" />
		
				<label>Application:</label>
				<select id="application" name="application">
				</select>
				
				<label>Component:</label>
				<select id="component" name="component">
				</select>
				
		        <label>Permission's name:</label><g:textField name="name" id="name" />
		        <label>Description:</label><g:textArea name="description" id="description" cols="20" rows="5"/>
		        
		        <g:actionSubmit id="submit" value="Add"/>
			</g:form>
		</div>
			
		<div id="permissionsTable" class="span-20 append-2 prepend-2 last itemsTable"></div>
		
	</div>
</body>
</html>