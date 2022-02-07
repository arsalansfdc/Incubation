({
    doInit : function(component, event, helper) {
        var accountId = component.get("v.recordId");
        var action = component.get("c.getAllAssets");
        var noRelAsset = component.get("v.noRelatedAssets");
        action.setParams({ accountId : accountId });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var assetList = response.getReturnValue();
                if(assetList == null){
                    noRelAsset = true;
                    component.set('v.noRelatedAssets',noRelAsset);
                } else {
                	component.set("v.assetList", assetList);
                }
               
            }          
        });
        $A.enqueueAction(action);       
    }
})