<script type="text/javascript" src="${resource(dir: "js", file: "utils.js")}"></script>
<script type="text/javascript" src="${resource(dir: "js", file: "gui.js")}"></script>

<g:javascript>

/**
	Creates a new updater which oversees changes on a element.
	@param managedElementId id of the html element to be overseen.
**/
function SlaveDataUpdater(managedElementId) {
	if (!SlaveDataUpdater.updaters) {
		SlaveDataUpdater.updaters = {}
	}
	
	SlaveDataUpdater.updaters[managedElementId] = this;
	this.master = $('#' + managedElementId);
	this.slaves = [];
	
	this.master.bind('change', this.changed);
}

SlaveDataUpdater.retrieveMasterFromId = function(masterId) {
	return (SlaveDataUpdater.updaters[masterId]);
}

SlaveDataUpdater.prototype.changed = function(e) {
	var updater = SlaveDataUpdater.retrieveMasterFromId(this.id);
	var id = updater.master.val();
	
	for (var i = 0; i < updater.slaves.length; i++) {
		var slave = updater.slaves[i];
		
		if (slave.data.controller === 'component') {
			updater.callFunctionForComponent(slave.data.action, id, this.id);
		} else if (slave.data.controller === 'application') {
			updater.callFunctionForApplication(slave.data.action, id, this.id);
		}
						
	}
}

SlaveDataUpdater.prototype.callFunctionForComponent = function(actionName, id, updaterId) {
	if (actionName === 'loadCompagnyApp') {
		${remoteFunction(controller: 'component', action: 'loadCompagnyApp2', params: "'id=' + id + '&updaterId=' + updaterId", onSuccess: "onSuccessLoadApplications2(arguments)", onFailure: "error(arguments)")}
	}
}


SlaveDataUpdater.prototype.callFunctionForApplication = function(actionName, id, updaterId) {
	if (actionName === 'loadApplicationComponents') {
		${remoteFunction(controller: 'application', action: 'fetchComponents', params: "'id=' + id + '&updaterId=' + updaterId", onSuccess: "onSuccessLoadApplications2(arguments)", onFailure: "error(arguments)")}
	}
}


SlaveDataUpdater.prototype.dispatch = function(dispatchInfo) {
	
	for (var i = 0; i < this.slaves.length; i++) {
		var slave = this.slaves[i];
		
		if (slave.type === 'select') {
			fillHtmlSelectOptionsWithAjaxElements(slave.elem[0].id, dispatchInfo[slave.data.listName]);
			
			// a super slave is a slave element which is a master too for others.
			var superSlave = SlaveDataUpdater.retrieveMasterFromId(slave.elem[0].id);
			if (superSlave) {
				superSlave.launch();
			}
			
		} else if (slave.type === 'table') {
			this.generateHtmlTable(slave, dispatchInfo[slave.data.listName]);
		}
	}
}

SlaveDataUpdater.prototype.generateHtmlTable = function(slave, itemsList) {
	function addColumnsHeaderWithCSSClass(header, columns) {
		var count = header.length;
		for (var i = 0; i < columns.length; i++) {
			if (columns[i] === 'id') {
				header[count] = ['ID', 'idColumn'];
			} else {
				header[count] = [columns[i], 'nameColumn'];
			}
			
			count++;
		}
		
		return header;
	}
	
	var extension;
	if (typeof(slave.data.itemNameForEdit) == 'undefined') {
		extension = '';
	}

	var div = document.createElement('div');
	var divId = slave.elem[0].id;
	div.setAttribute('id', divId);
	div.setAttribute('class', 'span-20 append-2 prepend-2 itemsTable');

	var table = document.createElement('table');
	addTableHeader(addColumnsHeaderWithCSSClass([table],slave.data.columns));
	
	addItems(table, itemsList, extension);

	div.appendChild(table);
	
	$('#' + divId).replaceWith(div);
}

function onSuccessLoadApplications2(ajaxArgs) {
	var map = $.parseJSON(ajaxArgs[2].responseText);
	var updater = SlaveDataUpdater.retrieveMasterFromId(map.updaterId);
	
	updater.dispatch(map);
}

SlaveDataUpdater.prototype.onLoadSlave = function(ajaxArgs) {
	loadedApplicationsList(ajaxArgs)
}


SlaveDataUpdater.prototype.selectMaster = function(selectedOptionId) {
	var appHtmlElem = this.master[0];
	
	if (selectedOptionId == '0') {
		var selectedOptionId = appHtmlElem.options[0].value;
	}
	
	this.master.val(selectedOptionId);	
}

SlaveDataUpdater.prototype.launch = function() {
	this.selectMaster(0);
	this.changed.apply(this.master[0]);
}

/**
	Adds a slave view. A slave view is a view is updated when the managed element
	is changed.
	
	@param slaveId Html ID of the element has to be updated.
	@params slaveType A string determines the type of the slave view. It could be "select" or "table".
	@params itemData Object defines data to take from items for slave's updating
**/
SlaveDataUpdater.prototype.addSlaveView = function(slaveId, slaveType, itemData) {
	var slave = {
		elem: $('#' + slaveId),
		type: slaveType,
		data: itemData
	};
	
	this.slaves[this.slaves.length] = slave;
}

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

function addTableHeader(args) {
	var o = args[0];
	var thead = document.createElement('thead');
	var tr = document.createElement('tr');
	for (var i = 1; i < args.length; i++) {
		var td = document.createElement('th');
		td.setAttribute('class', args[i][1]);
		td.textContent = args[i][0];
		thead.appendChild(td);		
	}
	
	thead.appendChild(tr);
	o.appendChild(thead);
}

function addItems(table, items, ext) {
	
	var tbody = document.createElement('tbody');
	for (var i = 0; i < items.length; i++) {
		var tr = document.createElement('tr');
		var td = document.createElement('td');
		td.textContent = items[i].id;
		tr.appendChild(td);
		
		td = document.createElement('td');
		var a = document.createElement('a');
		var link = "${createLink(action:'edit')}";
		link+= ext + '/' + items[i].id;
		a.setAttribute('href', link);
		a.textContent = items[i].name;
		td.appendChild(a);
		
		tr.appendChild(td);
		
		tbody.appendChild(tr);
	}
	
	table.appendChild(tbody);
}

function formatHtmlList(jqExtArgs) {
	var itemsList = $.parseJSON(jqExtArgs[2].responseText);
	var modifiedDiv = jqExtArgs[3];
	var extension = jqExtArgs[4];
	
	if (typeof(extension) == 'undefined') {
		extension = '';
	}

	var div = document.createElement('div');
	div.setAttribute('id', modifiedDiv);
	div.setAttribute('class', 'span-20 append-2 prepend-2 itemsTable');

	var table = document.createElement('table');
	addTableHeader([table, ['ID', 'idColumn'], ['Name', 'nameColumn']]);
	addItems(table, itemsList, extension);

	div.appendChild(table);
	
	$('#' + modifiedDiv).replaceWith(div);
		    	
}

function formatHtmlList2(itemsList, divId, extension) {
	
	if (typeof(extension) == 'undefined') {
		extension = '';
	}

	var div = document.createElement('div');
	div.setAttribute('id', divId);
	div.setAttribute('class', 'span-20 append-2 prepend-2 itemsTable');

	var table = document.createElement('table');
	addTableHeader([table, ['ID', 'idColumn'], ['Name', 'nameColumn']]);
	addItems(table, itemsList, extension);

	div.appendChild(table);
	
	$('#' + divId).replaceWith(div);
		    	
}


</g:javascript>