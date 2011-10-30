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
	 <script type="text/javascript" src="${resource(dir:'js', file:'RumalHTMLItem.js')}"></script>
  	
	 <title>Add a new company</title>
	 
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
  
	  <h1>Add Company</h1>

	  <hr>
	  
	  <div class="span-18 last prepend-3 append-3">
	  	<div class="info">
	  	Fill the form below with company's information.<br/>
	  	<b>Note:</b> Company's name must be filled and unique.	  	
	  	</div>
	  </div>
	  
	  <div class="span-15 last prepend-5">
	  	<g:render template="/compagny/companyForm" model="['actionType' : 'add']"></g:render>
	  </div>
	  
	  <g:render template="/list"/>
	
  </div>
  </body>
</html>