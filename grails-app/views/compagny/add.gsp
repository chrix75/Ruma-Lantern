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
  	 <g:render template="/header" model="[title: 'Add a company']"/>
	 
	 <g:javascript>
  		function updateCompaniesList(node) {
  			${remoteFunction(controller: 'compagny', action: 'loadCompanies', onSuccess: "arguments[arguments.length] = node ; onNodesLoaded(arguments)", onFailure: "error(arguments)")}
  		}    	
	 
	 
	 	$(document).ready(function() {
	  		root = RumalRoot();
	  		
	  		companiesTable = root.addTableChild("companiesTable", undefined, "${createLink(action:'edit')}", "${createLink(action:'delete')}");
	  		companiesTable.setHeader([ {name: "ID", prop: "id", htmlClass: "idColumn"}, {name: "Company", prop: "name", htmlClass: "nameColumn"}]);
	 	
	 	
	 		bindDetailsPanel();	 		
	 		$("#idTable").attr('id', 'companiesTable');
	 		
	 		updateCompaniesList(companiesTable);
		 	});
	 </g:javascript>
  </head>
  
  <body>
  
  <div class="container main">
  
  	  <g:applyLayout name="pagetitle">Add a company</g:applyLayout>
  	  
	  <g:applyLayout name="informationbanner">
	  	Fill the form below with company's information.<br/>
	  	<b>Note:</b> Company's name must be filled and unique.	  	
	  </g:applyLayout>
  	  
  
	  <div class="span-15 last prepend-5">
	  	<g:render template="/compagny/companyForm" model="['actionType' : 'add']"></g:render>
	  </div>
	  
	  <g:render template="/list"/>
	
  </div>
  </body>
</html>