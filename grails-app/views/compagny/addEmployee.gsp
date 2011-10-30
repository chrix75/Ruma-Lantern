<%@ page import="org.rumal.bo.Compagny" contentType="text/html;charset=UTF-8" %>
<html>
  <head>
	<g:render template="/header" model="[title: 'Add an employee']"/>  	
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
  	  <g:applyLayout name="pagetitle">Add an employee</g:applyLayout>

	  <g:if test="${flash.message}">
		  	<g:applyLayout name="errorbanner">
			<g:message code="${flash.message}" args="[employee?.email]"/>
			</g:applyLayout>	  	
	  </g:if>
	  <g:else>
		  <g:applyLayout name="informationbanner">
		  	Select the company where employee should be added.<br/>
		  	Fill the form below with the new employee's information.<br/>
		  	<b>Note:</b> All fields are required to validate new entry.	  	
		  </g:applyLayout>
	  </g:else>
	  
	  
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
		      
			  	
		      <g:submitButton name="addEmployee" value="Add"/>
		  </g:form>
	  </div>
	  
	  <g:render template="/list"/>
	  
  </div>
  </body>
</html>