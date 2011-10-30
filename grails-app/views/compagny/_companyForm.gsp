 <g:form action="${actionType}">
 
     <g:hiddenField name="validate" value="true"/>
     
     <g:if test="${actionType == 'edit'}">
     <g:hiddenField name="cieId" value="${company.id}"/>
     </g:if>
     
     <p>
     	<label>Company name:</label><g:textField name="name" value="${fieldValue(bean:company, field:'name')}"/>
     </p>
     
     <g:hasErrors bean="${company}" field="name">
      <p class="inputError">
	      <g:eachError bean="${company}" field="name">
             	<g:message error="${it}"/>
        	  </g:eachError>
      </p>
     </g:hasErrors>
     
     <p>
     	<label>SIRET:</label><g:textField name="siret" value="${fieldValue(bean:company, field:'siret')}"/>
     </p>
     
     <p>
     	<label>Zip Code:</label><g:textField name="zipcode" value="${fieldValue(bean:company, field:'zipcode')}"/>
     </p>
     
     <g:if test="${actionType == 'edit'}">
     <g:submitButton name="addCompany" value="Edit"/>
     <a class="cancel" href="${createLink(action:'add')}">Cancel</a>
     </g:if>
     <g:else>
      	  <g:submitButton name="addCompany" value="Add"/>
     </g:else>

 </g:form>