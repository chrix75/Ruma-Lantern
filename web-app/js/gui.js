function error(ajaxResponse) {
	alert('Error Ploum');
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

