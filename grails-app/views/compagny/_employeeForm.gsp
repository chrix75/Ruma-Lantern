 <g:form action="${actionName}">
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
