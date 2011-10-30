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
  
  	<g:render template="/header" model="[title: 'Edit company']"/>
	 
  </head>
  
  <body>
  
  <div class="container main">
  
   	  <g:applyLayout name="pagetitle">Edit company's information</g:applyLayout>
	  
	  <g:applyLayout name="informationbanner">
	  	Fill the form below with company's information.<br/>
	  	<b>Note:</b> Company's name must be filled and unique.	  	
	  </g:applyLayout>
	  
	  <div class="span-15 last prepend-5">
	  	<g:render template="/compagny/companyForm" model="['actionType' : 'edit']"></g:render>

	  </div>
	
  </div>
  </body>
</html>