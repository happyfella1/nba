var resultGrid = null;
var resultGridSortColumn = '';
var resultGridColumnFilters = {};

$(function() {
	$('#searchInput').focus()
		.keypress(function (e) {
	    	if(e.keyCode == 13){
	        	search();
	    	}
		});
});

search = function() {
	$.ajax({
		type: 'POST',
		url: '/search', 
		dataType: 'json',
		data: {'searchString': $('#searchInput').val()},
		success: function(data) {
			setupResultGrid(data);
		}
	});
}

setupResultGrid = function(results) {
	var dataView, groupItemMetadataProvider;
	var columns = [
	               	{id: "name", name: "Name", field: "name", sortable: true,
	               		formatter: linkFormatter = function (row, cell, value, columnDef, dataContext) {
	                        return '<a href="' + dataContext['url'] + '" target="_blank">' + value + '</a>';
	                    }
               		},
	               	{id: "position", name: "Position", field: "position", sortable: true},
	               	{id: "college", name: "College", field: "college", sortable: true},
	               	{id: "draftYear", name: "Draft", field: "draftYear", sortable: true},
	               	{id: "debutYear", name: "Debut", field: "debutYear", sortable: true}
    ];
	var options = {
			explicitInitialization: true,
	        enableCellNavigation: true,
	        enableColumnReorder: false,
	        forceFitColumns: true,
	        autoHeight: true,
	        showHeaderRow: true,
	        headerRowHeight: 37
    };

    groupItemMetadataProvider = new Slick.Data.GroupItemMetadataProvider();

    dataView = new Slick.Data.DataView({
        groupItemMetadataProvider: groupItemMetadataProvider,
        inlineFilters: true
    });
    // wire up model events to drive the grid
    dataView.onRowCountChanged.subscribe(function (e, args) {
    	resultGrid.updateRowCount();
    	resultGrid.render();
    });
    dataView.onRowsChanged.subscribe(function (e, args) {
    	resultGrid.invalidateRows(args.rows);
    	resultGrid.render();
    });

    resultGrid = new Slick.Grid('#searchResults',
        dataView,
        columns,
        options);
    resultGrid.registerPlugin(groupItemMetadataProvider);
    resultGrid.setSelectionModel(new Slick.CellSelectionModel());
    resultGrid.onSort.subscribe(function (e, args) {
    	resultGridSortColumn = args.sortCol.field;
        dataView.sort(resultGridComparer, args.sortAsc);
    });
    
    $(resultGrid.getHeaderRow()).delegate(":input", "change keyup", function (e) {
		var columnId = $(this).data("columnId");
		if (columnId != null) {
			resultGridColumnFilters[columnId] = $.trim($(this).val());
		    dataView.refresh();
	    }
    });
    resultGrid.onHeaderRowCellRendered.subscribe(function(e, args) {
    	$(args.node).empty();
    	$('<input type="text" width="' + (resultGrid.getColumns(args.column.id).width - 4) + '" />')
      	 	.data("columnId", args.column.id)
      	 	.val(resultGridColumnFilters[args.column.id])
      	 	.appendTo(args.node);
    });

    $('#searchResults .grid-header .ui-icon')
        .addClass('ui-state-default ui-corner-all')
        .mouseover(function (e) {
            $(e.target).addClass('ui-state-hover');
        })
        .mouseout(function (e) {
            $(e.target).removeClass('ui-state-hover');
        });

    $('#searchResults').show();
    resultGrid.init();
    
    dataView.beginUpdate();
    dataView.setItems(results, 'name');
    dataView.setFilter(filterResultGrid);
    dataView.endUpdate();
}

filterResultGrid = function(item) {
	for (var columnId in resultGridColumnFilters) {
		if (columnId !== undefined && resultGridColumnFilters[columnId] !== "") {
			var column = resultGrid.getColumns()[resultGrid.getColumnIndex(columnId)];
			if (item[column.field].toLowerCase().indexOf(resultGridColumnFilters[columnId].toLowerCase()) < 0) {
				return false;
			}
		}
    }
    return true;
}

resultGridComparer = function(a, b) {
    var x = a[resultGridSortColumn], y = b[resultGridSortColumn];
    return (x == y ? 0 : (x > y ? 1 : -1));
}