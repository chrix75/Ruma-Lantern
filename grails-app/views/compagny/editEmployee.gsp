<%@ page import="org.rumal.bo.Compagny" contentType="text/html;charset=UTF-8" %>
<html>
  <head>
	<g:render template="/header" model="[title: 'Edit employee\'s information']"/>  	
  	<g:render template="/functions"></g:render>
  	
  	<g:javascript>
  		var employeesTable;
  		var companies;
  		
		
  		function updateEmployeesList(id, node) {
			${remoteFunction(controller: 'compagny', action: 'loadCompanyEmployees', params: "'id=' + id + '&updaterId=1'", onSuccess: "arguments[arguments.length] = node ; onNodesLoaded(arguments)", onFailure: "error(arguments)")}
  		}    	
  	
		$(document).ready(function() {
	  		companies = RumalRoot("cie");
	  		employeesTable = companies.addTableChild("employeesTable", updateEmployeesList, "${createLink(action:'editEmployee')}", "${createLink(action:'deleteEmployee')}");
	  		employeesTable.setHeader([ {name: "ID", prop: "id", htmlClass: "idColumn"}
	  			, {name: "First Name", prop: "firstName", htmlClass: "nameColumn"}
	  			, {name: "Last Name", prop: "lastName", htmlClass: "nameColumn"}]);
	  		
	  		nodesDict = { cie: companies };
	  		
	  		$("#cie").bind("change", nodeChanged);		
	  		
	  		$("#cie").trigger("change");
	  		
	  		bindDetailsPanel();	 		
	 		$("#idTable").attr('id', 'employeesTable');
	  		
		});
  	</g:javascript>
  </head>
  
  <body>
  <div class="container main">
  	  <g:applyLayout name="pagetitle">Edit employee's information</g:applyLayout>

	  <g:if test="${flash.success}">
		  	<g:applyLayout name="successbanner">
			<g:message code="${flash.success}" />
			</g:applyLayout>	  	
	  </g:if>
	  <g:elseif test="${flash.message}">
		  	<g:applyLayout name="errorbanner">
			<g:message code="${flash.message}" args="[employee?.email]"/>
			</g:applyLayout>	  	
	  </g:elseif>
	  <g:else>
		  <g:applyLayout name="informationbanner">
		  	Select the company where employee should be added.<br/>
		  	Fill the form below with the new employee's information.<br/>
		  	<b>Note:</b> All fields are required to validate new entry.	  	
		  </g:applyLayout>
	  </g:else>
	  
	  
	  <div class="span-15 last prepend-5">
	  	<g:render template="/compagny/employeeForm" model="['actionName': 'addEmployee', Compagny: Compagny]"/>
	  </div>
	  
  </div>
  </body>
</html>