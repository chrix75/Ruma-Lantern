
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
  	 
  	
  	<title>Add an application to a company</title>
  	
  	<g:render template="/functions"></g:render>
  
  	<g:javascript>
  		var controller;		
  	
		$(document).ready(function() {
			controller = new SlaveDataUpdater('cie');
			controller.addSlaveView('applicationsTable', 'table', {
			columns: ['id', 'name'],
			controller: 'component',
			action: 'loadCompagnyApp',
			listName: 'applications' });
			
			controller.launch()
		});
  	</g:javascript>
  </head>
  
  <body>
  <div class="container main">
	  <h1>Add Application</h1>
	  
	  <div class="span-15 last prepend-5">
		  <g:form action="add">
		      <g:hiddenField name="validate" value="true"/>
		      <p><label>Company:</label><g:select id="cie" from="${Compagny.list()}" optionKey="id" optionValue="name" name="cieId"/></p>
		      <p><label>App's name:</label><g:textField name="name"/></p>
		      <p><label>Description:</label><g:textArea name="description" cols="20" rows="5"/></p>
		
		      <g:actionSubmit value="Add"/>
		  </g:form>
	  </div>
	  
	  <div id="applicationsTable" class="itemsTable span-20 append-2 prepend-2"></div>
	  
  </div>
  </body>
</html>