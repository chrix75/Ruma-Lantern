/*
	This code describes behaviour for master / slace components.
*/

function RumalNode() {
	this.children = [];
	this.childrenCount = 0;
	this.ajaxFunction = undefined;
}

RumalNode.prototype.childrenAt = function(index) {
	return(this.children[index]);
};


RumalNode.prototype.changedNodesAfterChange = function() {
	var allDescendants = [];

	function fetchChildren(node) {
		for(var i = 0; i < node.childrenCount; i++) {
			allDescendants[allDescendants.length] = node.childrenAt(i);
			// remove recursive call because recursivity is done by client-side code
			//fetchChildren(node.childrenAt(i));
		}
	}
	
	fetchChildren(this);
	
	return allDescendants;
};

/*
 * Constructors 
 */
function RumalSelectNode(nodeName) {
	RumalNode.call(this);
	this.name = nodeName;
	this.constructor = RumalSelectNode;
}

function RumalTableNode(nodeName) {
	RumalNode.call(this);
	this.name = nodeName;
	this.constructor = RumalTableNode;
	this.columnNames = [];
	this.columnProps = [];
	this.columnClasses = [];
	this.rows = [];
	this.columnsCount = 0;
}

RumalSelectNode.prototype = new RumalNode();
RumalTableNode.prototype = new RumalNode();



/*
 * Select Node's methods
 */
RumalSelectNode.prototype.setKeys = function(keys) {
	this.keyName = keys.optionKey;
	this.valueName = keys.optionValue;
};

RumalSelectNode.prototype.setItems = function(values) {
	this.items = [];
	for (var i = 0; i < values.length; i++) {
		this.items[i] = {key: values[i][this.keyName], value: values[i][this.valueName]};
	}
};

RumalSelectNode.prototype.addSelectChild = function(childName, ajaxFunction) {
	var child = new RumalSelectNode(childName);
	child.ajaxFunction = ajaxFunction;
	this.children[this.children.length] = child;
	
	this.childrenCount++;
	return child;
};

RumalSelectNode.prototype.addTableChild = function(childName, ajaxFunction, editActionName) {
	var child = new RumalTableNode(childName);
	child.ajaxFunction = ajaxFunction;
	child.editActionName = editActionName;
	this.children[this.children.length] = child;
	this.childrenCount++;
	return child;
};

/*
 * Table node's methods
 */
RumalTableNode.prototype.setHeader = function(header) {
	
	this.columnsCount = header.length;
	for (var i = 0; i < this.columnsCount; i++) {
		this.columnNames[i] = header[i].name;
		this.columnProps[i] = header[i].prop;
		this.columnClasses[i] = header[i].htmlClass;
	}
};

RumalTableNode.prototype.getItem = function(r, c) {
	return this.rows[r][c];
};

RumalTableNode.prototype.getHeaderColumn = function(index) {
	return {headerName: this.columnNames[index], headerClass: this.columnClasses[index]};
}

RumalTableNode.prototype.setRows = function(items) {
	function extractRow(item) {
		var row = [];
		for (var i = 0; i < this.columnProps.length; i++) {
			row[i] = item[this.columnProps[i]];
		}
		
		return row;
	}
	
	// clear rows array of previous values
	this.rows = [];
	
	for (var i = 0; i < items.length; i++) {
		this.rows[i] = extractRow.call(this,items[i]);
	}
};

/*
 * Creates a new root of items. Conceptually, this root is a select html component.
 * Thus, the root has items defined by a key and a value.
 * 
 */
function RumalRoot(rootName) {
	var node = new RumalSelectNode(rootName);
	return node;
}
