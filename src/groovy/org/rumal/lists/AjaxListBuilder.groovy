package org.rumal.lists


import groovy.xml.MarkupBuilder;


class AjaxListBuilder {
	
	/**
	 * Generates code is the translation of items list into HTML.
	 *  
	 * @param itemsList List of the items are used to generate the code. Each item of this list 
	 * must have properties id and name.
	 * 
	 * @return The HTML code string.
	 * 
	 */
	static String htmlList(itemsList) {
		if (itemsList.size()) {
			StringWriter writer = new StringWriter()
			def builder = new MarkupBuilder(writer)
	
			builder.table {
				tr {
					thead {
						th(class:'idColumn', 'ID')
						th(class:'nameColumn', 'Name')
					}
				}
	
				itemsList.each { item ->
					tr {
						td "${item.id}"
						td "${item.name}"
					}
				}
		
			}
			
			return writer.toString()
		} else {
			return ''
		}
	
	}
}
