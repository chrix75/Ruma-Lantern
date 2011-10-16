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
	
	<title>Add a component to application</title>
	

	<g:render template="/functions"></g:render>
	
	<g:javascript>
		var company;
		var application;
		var componentsTable;
		
		function updateApplicationsOptions(id, node) {
			${remoteFunction(controller: 'component', action: 'loadCompagnyApp2', params: "'id=' + id + '&updaterId=1'", onSuccess: "arguments[arguments.length] = node ; onOptionsLoaded(arguments)", onFailure: "error(arguments)")}
		}
		
  		function updateComponentsList(id, node) {
			${remoteFunction(controller: 'permission', action: 'loadComponentsByApp', params: "'id=' + id + '&updaterId=1'", onSuccess: "arguments[arguments.length] = node ; onNodesLoaded(arguments)", onFailure: "error(arguments)")}
  		}    	
		
  	
		$(document).ready(function() {
	  		company = RumalRoot("cie");
	  		application = company.addSelectChild("application", updateApplicationsOptions);
	  		application.setKeys({optionKey: "id", optionValue: "name" });
	  		componentsTable = application.addTableChild("componentsTable", updateComponentsList, "${createLink(action:'edit')}");
	  		componentsTable.setHeader([ {name: "ID", prop: "id", htmlClass: "idColumn"}, {name: "Name", prop: "name", htmlClass: "nameColumn"}]);
	  		
	  		nodesDict = { cie: company, application: application };
	  		
	  		$("#cie").bind("change", nodeChanged);
	  		$("#application").bind("change", nodeChanged);		
	  		
	  		$("#cie").trigger("change");
	  		
		});

    </g:javascript>
</head>

<body>
	<div class="container main">
	
		<h1>Add Component</h1>
		
		<div class="span-15 last prepend-5">
		<g:form action="add">
			<g:hiddenField name="validate" value="true"/>
			<p>
				<label>Companies:</label>
				<g:select from="${Compagny.list()}" name="cie" id="cie"
					optionKey="id" optionValue="name" />
			</p>
			
			<p>	
				<label>Application:</label>
				<select id="application" name="application" >
				</select>
			</p>			
			
	        <p><label>Comp's name:</label><g:textField name="name" id="name"/></p>
	        <p><label>Description:</label><g:textArea name="description" id="description" cols="20" rows="5"/></p>
	        
	        <g:actionSubmit id="submit" value="Add"/>
		</g:form>
		</div>
		
		<div id="componentsTable" class="span-20 append-2 prepend-2 itemsTable"></div>
		
	</div>
</body>
</html>