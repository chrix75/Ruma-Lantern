<script type="text/javascript" src="${resource(dir: "js", file: "utils.js")}"></script>
<script type="text/javascript" src="${resource(dir: "js", file: "gui.js")}"></script>

<g:javascript>

function onSuccessLoadApplications(ajaxArgs) {
	loadedApplicationsList(ajaxArgs)
	
	if ($('#application').length > 0) {
		selectOptionById('application', "${params.currentApp}");
		selectedApp();
	}
}
	
function onSuccessLoadEmployees(ajaxArgs) {
	loadedEmployeesList(ajaxArgs)
	
	if ($('#employee').length > 0) {
		selectOptionById('employee', "${params.currentEmployee}");
		selectedEmployee();
	}
}

function selectedEmployee() {
	var id = $('#employee :selected').val();
	if ($('#usersTable').length > 0) {
		${remoteFunction(controller: "application", action: "fetchUsers", params: "'id=' + id", onSuccess: "arguments[arguments.length] = 'usersTable' ; formatHtmlList(arguments);", onFailure: "error(arguments)")}
	}
}

function onSuccessLoadComponents(ajaxArgs) {
	loadedComponentsList(ajaxArgs)
	
	selectOptionById('component', "0");
	selectedComponent();
}

function selectedComponent(e) {
	var compId = $('#component :selected').val();
	if (compId > 0) {
		if ($('#permissionsTable').length > 0) {
			${remoteFunction(controller: "component", action: "fetchPermissions", params: "'id=' + compId", update:[success:"permissionsTable"], onFailure: "error(arguments)")}
		}
	}
}

// Called function when client receives a list of application's permissions.
// Note: These permissions are grouped by application's components.
function onSuccessRetrievePermissionsByComponents(jqArgs) {
	var permissionsByComponent = $.parseJSON(jqArgs[2].responseText);
	
	var newList = document.createElement('div');
	newList.setAttribute('id', 'permissionsList');
	
	for (var i = 0; i < permissionsByComponent.length ; i++) {
		// component
		var header = document.createElement('h3');
		header.textContent = permissionsByComponent[i].name;
		newList.appendChild(header);
		
		var permissionsCount = permissionsByComponent[i].permissions.length;
		
		if (permissionsCount > 0) {
			// adds permissions
			for (var j = 0; j < permissionsCount; j++) {
				var permission = permissionsByComponent[i].permissions[j];
				var cb = document.createElement('input');
				cb.setAttribute('type', 'checkbox');
				cb.setAttribute('id', permission.id);
				if (permission.checked) {
					cb.setAttribute('checked', 'true');
				}
				cb.setAttribute('name',  'P' + permission.id);
				newList.appendChild(cb);
				
				var label = document.createTextNode(permission.name);
				newList.appendChild(label);
			}
		} else {
			newList.appendChild(document.createTextNode('No defined permissions.'));
		}
	}
	
	$('#permissionsList').replaceWith(newList);
	
}


function selectedApp(e) {
	var appId = $('#application :selected').val();
	
	if (appId > 0) {
		if ($('#componentsTable').length > 0) {
			${remoteFunction(controller: "application", action: "fetchComponents", params: "'id=' + appId", update:[success:"componentsTable"], onFailure: "error(arguments)")}
		}
		
		if ($('#rolesTable').length > 0) {
			${remoteFunction(controller: "application", action: "fetchRoles", params: "'id=' + appId", onSuccess: "arguments[arguments.length] = 'rolesTable' ; arguments[arguments.length + 1] = 'Role' ; formatHtmlList(arguments);", onFailure: "error(arguments)")}
		}
		
		if ($('#component').length > 0) {
			${remoteFunction(controller: "permission", action: "loadComponentsByApp", params: "'id=' + appId", onSuccess: "onSuccessLoadComponents(arguments)", onFailure: "error(arguments)")}	
		}
		
		if ($('#permissionsList').length > 0) {
			${remoteFunction(controller: "application", action: "retrievePermissionsByComponent", params: "'id=' + appId", onSuccess: "onSuccessRetrievePermissionsByComponents(arguments)", onFailure: "error(arguments)")}
		}
		
	}
}


function selectedCie(e) {
	var cieId = $('#cie :selected').val();
	${remoteFunction(controller: "component", action: "loadCompagnyApp", params: "'id=' + cieId", onSuccess: "onSuccessLoadApplications(arguments)", onFailure: "error(arguments)")}
	
	if ($('#employee').length >0) {
		${remoteFunction(controller: "compagny", action: "loadCompanyEmployees", params: "'id=' + cieId", onSuccess: "onSuccessLoadEmployees(arguments)", onFailure: "error(arguments)")}	
	}
	
	if ($('#applicationsTable').length > 0) {
		${remoteFunction(controller: "compagny", action: "fetchApplications", params: "'id=' + cieId", onSuccess: "arguments[arguments.length] = 'applicationsTable' ; formatHtmlList(arguments);", onFailure: "error(arguments)")}
	}
	
	if ($('#employeesTable').length > 0) {
		${remoteFunction(controller: "compagny", action: "fetchEmployees", params: "'id=' + cieId", onSuccess: "arguments[arguments.length] = 'employeesTable' ; formatHtmlList(arguments);", onFailure: "error(arguments)")}
	}
}




</g:javascript>