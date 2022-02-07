/*******************************************************************************************
* @Name         AssetsController 
* @Author       Arsalan Khan
* @Date         02/02/2022
* @Description  This class contains method for getting all the parent assets 
				and child assets related to an account.  
*******************************************************************************************/
public class AssetsController {    
    @AuraEnabled
    public static List<AssetWrapper> getAllAssets(String accountId) { 
        List<Asset> lstAsset=[select id,name,Product2.Name,Product2.ProductCode,Product2.Family,ParentId from Asset 
                              where Accountid=:accountId];
        Map<Id,Asset> parentMap = new map<Id,Asset>();
        List<Asset> childrenList= new List<Asset>();
        for(Asset eachAssetObj : lstAsset){
            if(String.isBlank(eachAssetObj.ParentId)){
                parentMap.put(eachAssetObj.id,eachAssetObj);
            } else {  
                childrenList.add(eachAssetObj);
            }                                  
        } 
        
        Map<Id, List<Asset>> assetIdVsChildAssetsMap = new Map<Id, List<Asset>>();
        for (Asset eachAssetObject : childrenList) {
            if (!assetIdVsChildAssetsMap.containsKey(eachAssetObject.ParentId)) {
                assetIdVsChildAssetsMap.put(eachAssetObject.ParentId, new List<Asset>());
            }
            assetIdVsChildAssetsMap.get(eachAssetObject.ParentId).add(eachAssetObject);           
        }
        
        Map<Asset,List<Asset>> assetVsListOfChildAssetsMap = new Map<Asset,List<Asset>>();   
        for (Id key : parentMap.keySet()) {
            Asset asObject=parentMap.get(key);
            List<Asset> assetList = assetIdVsChildAssetsMap.get(key);       
            assetVsListOfChildAssetsMap.put(asObject,assetList);
        } 
       
        List<AssetWrapper> assetWrapperList= new List<AssetWrapper>();               
        for (Asset key : assetVsListOfChildAssetsMap.keySet()) {
            AssetWrapper assetObj = new AssetWrapper();
            assetObj.assetObject=key;
            assetObj.childAssetList=assetVsListOfChildAssetsMap.get(key);
            assetWrapperList.add(assetObj);
        } 
        if(assetWrapperList.size() > 0){
            return assetWrapperList;
        } else {
            return null;
        }     
    }   
    public class AssetWrapper {
        @AuraEnabled  public Asset assetObject {get;set;}
        @AuraEnabled  public List<Asset> childAssetList {get;set;}
    }
}