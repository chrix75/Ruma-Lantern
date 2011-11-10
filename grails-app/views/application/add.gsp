
<%@ page import="org.rumal.bo.Compagny" contentType="text/html;charset=UTF-8" %>
<html>
  <head>
  	
	<g:render template="/header" model="[title: 'Add an application']"/>  	
  	<g:render template="/functions"></g:render>
  	 
  	
  	<title>Add an application to a company</title>
  
  	<g:javascript>
  		var applicationsTable;
  		var companies;
  		
		
  		function updateApplicationsList(id, node) {
  			${remoteFunction(controller: 'component', action: 'loadCompagnyApp', params: "'id=' + id + '&updaterId=1'", onSuccess: "arguments[arguments.length] = node ; onNodesLoaded(arguments)", onFailure: "error(arguments)")}
  		}    	
  	
		$(document).ready(function() {
	  		companies = RumalRoot("cie");
	  		applicationsTable = companies.addTableChild("applicationsTable", updateApplicationsList, "${createLink(action:'edit')}", "${createLink(action:'delete')}");
	  		applicationsTable.setHeader([ {name: "ID", prop: "id", htmlClass: "idColumn"}, {name: "Application", prop: "name", htmlClass: "nameColumn"}]);

			// to help general functions to work
			nodesDict = { cie: companies };
				  		
	  		$("#cie").bind("change", nodeChanged);		
	  		$("#cie").trigger("change");
	  		
	  		bindDetailsPanel();
	  		$("#idTable").attr('id', 'applicationsTable');
		});
  	</g:javascript>
  </head>
  
  <body>
  <div class="container main">
	  <g:applyLayout name="pagetitle">Add an application</g:applyLayout>
	  
	  <g:if test="${flash.message}">
	  <g:applyLayout name="errorbanner">
	  <g:message code="${flash.message}"/>
	  </g:applyLayout>	  	
	  </g:if>
	  
	  <g:render template="/application/applicationForm" model="[Company : Compagny, application : application, actionName: 'add']"/>
	  
	  <g:render template="/list"/>
	  
  </div>
  </body>
</html>