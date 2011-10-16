/*
 * This file defines global utility functions.
 * These functions are not concerned by business.
 * 
 */

function fillApplicationsArrayFromAjax(arr, jsonData) {
	arr.length = 0;

	for (var i = 0; i < jsonData.length; i++) {
		var item = jsonData[i];
		arr[arr.length] = new Option(item.value, item.key);
	}
}

/*
 * Initializes options of a select component with a AJAX response.
 * 
 * The select component to be filled is defined by its id.
 * 
 */
function fillHtmlSelectOptionsWithAjaxElements(selectElementId, jsonData) {
	
	var selector = '#' + selectElementId;
	if ($(selector).length > 0) {
		var element = $(selector)[0]; // convert object to html element
		fillApplicationsArrayFromAjax(element.options, jsonData);
	}
}
