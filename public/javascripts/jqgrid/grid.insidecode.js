$.fn.extend({
	/*
	*  
	* The toolbar has the following properties
	*	id of top toolbar: t_<tablename>
	*	id of bottom toolbar: tb_<tablename>
	*	class of toolbar: ui-userdata
	* elem is the toolbar name to which button needs to be added. This can be 
	*		#t_tablename - if button needs to be added to the top toolbar
	*		#tb_tablename - if button needs to be added to the bottom toolbar
	*/
	toolbarButtonAdd: function(elem,p){
		p = $.extend({
		caption : "newButton",
		title: '',
		buttonicon : 'ui-icon-newwin',
		onClickButton: null,
		position : "last"
	}, p ||{});
	var $elem = $(elem);
	var tableString="<table style='float:left;table-layout:auto;' cellspacing=\"0\" cellpadding=\"0\" border=\"0\" class='ui-toolbar-table'>";
	tableString+="<tbody> <tr></tr></table>";
	//console.log("In toolbar button add method");
		/* 
		* Step 1: check whether a table is already added. If not add
		* Step 2: If there is no table already added then add a table
		* Step 3: Make the element ready for addition to the table 
		* Step 4: Check the position and corresponding add the element
		* Step 5: Add other properties 
		*/
		//step 1 
		return this.each(function() {
			if( !this.grid)  { return; }
			if(elem.indexOf("#") != 0) { 
				elem = "#"+elem; 
			}
			//step 2
			if($(elem).children('table').length === 0){
				$(elem).append(tableString);
			}	
			//step 3
			var tbd = $("<td style=\"padding-left:1px;padding-right:1px\"></td>");
			$(tbd).addClass('ui-toolbar-button ui-corner-all').append("<div class='ui-toolbar-div'><span class='ui-icon "+p.buttonicon+"'></span>"+"<span>"+p.caption+"</span>"+"</div>").attr("title",p.title  || "")
			.click(function(e){
				if ($.isFunction(p.onClickButton) ) { p.onClickButton(); }
				return false;
			})
			.hover(
				function () {$(this).addClass("ui-state-hover");},
				function () {$(this).removeClass("ui-state-hover");}
			);
			if(p.id) {$(tbd).attr("id",p.id);}
			if(p.align) {$(elem).attr("align",p.align);}
			var findnav=$(elem).children('table');
			if(p.position ==='first'){
				if($(findnav).find('td').length === 0 ) {
					$("tr",findnav).append(tbd);
				} else {
					$("tr td:eq(0)",findnav).before(tbd);
				}
			} else {
				//console.log("not first");
				$("tr",findnav).append(tbd);
			}
		});
	}
});