var nodesDict;


function error(ajaxResponse) {
	alert('Error Ploum');
}

function toggleDetails(e) {
	if ($("#details img").hasClass("close")) {
		$("#details img").removeClass("close");
		$("#details img").addClass("open");
		
		$(".itemsTable").height("300px");
	} else {
		$("#details img").removeClass("open");
		$("#details img").addClass("close");
		
		$(".itemsTable").height("0");
 		}
 	}
 



function loadedComponentsList(args) {
	fillHtmlSelectOptionsWithAjaxElements("component", args[2]);
	updateFormItemsState();
}

function selectOptionById(selectedElemId, selectedOptionId) {
	var appHtmlElem = $('#' + selectedElemId)[0];
	
	if (selectedOptionId === '0') {
		var selectedOptionId = appHtmlElem.options[0].value;
	}
	
	$('#' + selectedElemId).val(selectedOptionId);	
}


function loadedEmployeesList(args) {
	fillHtmlSelectOptionsWithAjaxElements("employee", args[2]);
	updateFormItemsState();
}


function loadedApplicationsList(args) {
	fillHtmlSelectOptionsWithAjaxElements("application", args[2]);
	updateFormItemsState();
}

function loadedComponentsList(args) {
	fillHtmlSelectOptionsWithAjaxElements("component", args[2]);
	updateFormItemsState();
}


function existItems(selectId) {
	var select = $('#' + selectId)[0];
	if (!select) {
		return true;
	}
	
	return select.options.length > 0;
}

function updateFormItemsState() {
	var hasCompanies = existItems('cie');
	var hasApplications = existItems('application');
	var hasComponents = existItems('component');
	var hasPermissions = existItems('permission');

	if (!hasCompanies) {
		$('#application').prop('disabled', true);
		$('#component').prop('disabled', true);
		$('#permission').prop('disabled', true);
		$('#name').prop('disabled', true);
		$('#description').prop('disabled', true);
		$('#submit').prop('disabled', true);
		return;
	}
	
	if (!hasApplications) {
		$('#component').prop('disabled', true);
		$('#permission').prop('disabled', true);
		$('#name').prop('disabled', true);
		$('#description').prop('disabled', true);
		$('#submit').prop('disabled', true);
		return;
	}
	
	if (!hasComponents) {
		$('#permission').prop('disabled', true);
		$('#name').prop('disabled', true);
		$('#description').prop('disabled', true);
		$('#submit').prop('disabled', true);
		return;
	}
	
	$('#application').prop('disabled', false);
	$('#component').prop('disabled', false);
	$('#permission').prop('disabled', false);
	$('#name').prop('disabled', false);
	$('#description').prop('disabled', false);
	$('#submit').prop('disabled', false);
}

function addActionHeader(thead) {
	var td = document.createElement('th');
	td.setAttribute('class', 'actionColumn');
	td.textContent = "Actions";
	thead.appendChild(td);		
}

function js_addTableHeader(o, provider) {
	var thead = document.createElement('thead');
	var tr = document.createElement('tr');
	for (var i = 0; i < provider.columnNames.length; i++) {
		var td = document.createElement('th');
		var headerData = provider.getHeaderColumn(i);
		td.setAttribute('class', headerData.headerClass);
		td.textContent = headerData.headerName;
		thead.appendChild(td);		
	}
	
	addActionHeader(thead);
	
	thead.appendChild(tr);
	o.appendChild(thead);
}

function addDeleteButton(td, item, deleteLink) {
	var a = document.createElement('a');
	var link = deleteLink + '/' + item[0];
	a.setAttribute('href', link);

	var edit = document.createElement('div');
	edit.setAttribute('class', 'action actionDelete');
	a.appendChild(edit);
	
	td.appendChild(a);
}

function addEditButton(td, item, editLink) {
	var a = document.createElement('a');
	var link = editLink + '/' + item[0];
	a.setAttribute('href', link);

	var edit = document.createElement('div');
	edit.setAttribute('class', 'action actionEdit');
	a.appendChild(edit);
	
	td.appendChild(a);
}

function addActionColumn(tr, item, editLink, deleteLink) {
	var td = document.createElement('td');
	
	addEditButton(td, item, editLink);
	addDeleteButton(td, item, deleteLink);
	
	tr.appendChild(td);

}

function js_addItems(table, provider, editLink, deleteLink) {
	
	var tbody = document.createElement('tbody');
	for (var i = 0; i < provider.rows.length; i++) {
		var tr = document.createElement('tr');
		var td = document.createElement('td');
		td.textContent = provider.getItem(i,0);
		tr.appendChild(td);
		
		for(var j = 1; j < provider.columnsCount; j++) {
			td = document.createElement('td');
			td.textContent = provider.getItem(i,j);
			
			tr.appendChild(td);
		}
		
		addActionColumn(tr, provider.rows[i], editLink, deleteLink);
		
		tbody.appendChild(tr);
	}
	
	table.appendChild(tbody);
}  		
	

function bindDetailsPanel() {
	$("#details").bind("click", toggleDetails);
	$("#details img").addClass("close");
}

function buildHTMLTableList(provider, modifiedDiv) {

	var div = document.createElement('div');
	div.setAttribute('id', modifiedDiv);
	div.setAttribute('class', 'span-20 append-2 prepend-2 itemsTable');

	var table = document.createElement('table');
	js_addTableHeader(table, provider);
	js_addItems(table, provider, provider.editActionName, provider.deleteActionName);

	div.appendChild(table);
	
	div.style.height = $('#' + modifiedDiv).height();
	$('#' + modifiedDiv).replaceWith(div);
}

function onNodesLoaded(ajaxArgs) {
	var map = $.parseJSON(ajaxArgs[2].responseText);
	var node = ajaxArgs[3];
	var htmlElemId = node.name;
	
	if (map.items) {
		node.setRows(map.items);
	} else {
		node.setRows(map);
	}
	buildHTMLTableList(node, htmlElemId);
}

function onOptionsLoaded(ajaxArgs) {
	var map = $.parseJSON(ajaxArgs[2].responseText);
	var node = ajaxArgs[3];
	var htmlElemId = node.name;
	
	if (map.items) {
		node.setItems(map.items);
	} else {
		node.setItems(map);
	}
	
	fillHtmlSelectOptionsWithAjaxElements(htmlElemId, node.items);
	$("#" + htmlElemId ).trigger("change");
	
}

function updateNodes(htmlId) {
	
	function getParentsId(node) {
		var allId = {};
		for (var i = 0; i < node.parents.length; i++) {
			allId[node.parents[i].name] = $("#" + node.parents[i].name + " :selected").val();
		}
		
		return allId;
	}
	
	// parent's id by default (if a child has only one parent)
	var id = $("#" + htmlId + " :selected").val();

	// find nodes to update
	var changedNode = nodesDict[htmlId];
	var nodes = changedNode.changedNodesAfterChange();
	for (var i = 0; i < nodes.children.length; i++) {
		var currentChild = nodes.children[i];
		
		if (currentChild.parents.length == 1) {
			currentChild.ajaxFunction.call(this, id, currentChild);
		} else {
			// current child has several parents
			var allParentsId = getParentsId(currentChild);
			currentChild.ajaxFunction.call(this, allParentsId, currentChild);
		}
	}
	
}

function nodeChanged(evt) {
	var htmlId = evt.target.id;
	updateNodes(htmlId);
}
		


