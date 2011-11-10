 <div class="span-15 last prepend-5">
  <g:form action="${actionName}">
      <g:hiddenField name="validate" value="true"/>
      <g:hiddenField name="id" value="${application?.id}"/>
      <p><label>Company:</label><g:select id="cie" from="${Company.list()}" optionKey="id" optionValue="name" name="cieId" value="${application?.cieId}"/></p>
      <p><label>App's name:</label><g:textField name="name" value="${application?.name}"/></p>
      <p><label>Description:</label><g:textArea name="description" value="${application?.description}" cols="20" rows="5"/></p>

  	 <g:if test="${actionName == 'edit'}">
     <g:submitButton name="EditEmployee" value="Edit"/>
     <a class="cancel" href="${createLink(action:'add')}">Cancel</a>
     </g:if>
     <g:else>
     <g:submitButton name="AddEmployee" value="Add"/>
     </g:else>

  </g:form>
 </div>
