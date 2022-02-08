({
    doInit : function(component, event, helper) {
        var columns = [{
        type: 'text',
        fieldName: 'Name',
        label: 'Name'
    },
    {
        type: 'text',
        fieldName: 'ProductName',
        label: 'Product'
    },{
        type: 'text',
        fieldName: 'ProductCode',
        label: 'Product Code'
    },{
        type: 'Picklist',
        fieldName: 'ProductFamily',
        label: 'Product Family'
    }];
		component.set('v.gridColumns', columns);
        helper.getAssets(component);      
    
    }, 
    
    handleExpandAll : function(component, event, helper) {
        var tree = component.find('treeGrid');
        tree.expandAll();
    },
    
    handleCollapseAll : function(component, event, helper) {
        var tree = component.find('treeGrid');
        tree.collapseAll();
    }
})
