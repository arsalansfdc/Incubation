({
	getAssets : function(component,event) {
        var accountId = component.get("v.recordId");
		var action = component.get("c.fetchAccountAssetHierarchy");
        action.setParams({ accountId : accountId });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var assetList = response.getReturnValue();
                assetList = JSON.parse(JSON.stringify(assetList).split('children').join('_children'));
                component.set("v.gridData", assetList);
            }          
        });
        $A.enqueueAction(action); 
	}
})
