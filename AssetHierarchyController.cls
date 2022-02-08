/*******************************************************************************************
* @Name         AssetHierarchyController 
* @Author       Arsalan Khan
* @Date         07/02/2022
* @Description  This class contains method for getting all the parent assets 
and child assets related to an account.  
*******************************************************************************************/
public class AssetHierarchyController {
    //This method will fetch all the assets related to an account.
    @AuraEnabled(cacheable=true)
    public static List <HierarchyWrapper> fetchAccountAssetHierarchy( String accountId ) {
        try{
            List <HierarchyWrapper> listWrap = new List <HierarchyWrapper>();
            List<Asset> currentAsset = [ SELECT Id, RootAssetId FROM Asset WHERE AccountId =: accountId ];
            Set<Id> rootAssetIds = new Set<Id>();
            for(Asset asset : currentAsset) {
                if(asset.RootAssetId != null) {
                    rootAssetIds.add(asset.RootAssetId);
                }
            }
            List <Asset> listAssets = new List <Asset>();
            if(!rootAssetIds.isEmpty()) {
                listAssets = [ SELECT Id, Name, Product2.Name,ProductFamily,ProductCode, ParentId FROM Asset WHERE RootAssetId IN : rootAssetIds 
                              ORDER BY ParentId NULLS FIRST ];
            }
            for(Asset rootAsset : [ SELECT Id, RootAssetId, Name, Product2.Name,ProductFamily,ProductCode FROM Asset WHERE Id IN : rootAssetIds ]) {
                HierarchyWrapper rootAssetWrap = new HierarchyWrapper();
                rootAssetWrap.Name = rootAsset.Name;
                rootAssetWrap.ProductName = rootAsset.Product2.Name;
                rootAssetWrap.ProductCode = rootAsset.ProductCode;
                rootAssetWrap.ProductFamily = rootAsset.ProductFamily;
                rootAssetWrap.children = findRelations( listAssets, rootAsset.RootAssetId );
                listWrap.add( rootAssetWrap );
            }
            return listWrap;
        } catch(Exception ex){   
        }
        return null;
    }
    //This method will find the child relations between the Asset itself.
    public static List <HierarchyWrapper> findRelations(List<Asset> listAssets, Id rootAssetId) {
        try{
            List <HierarchyWrapper> listWrap = new List <HierarchyWrapper>();
            for (Asset objAsset : listAssets) {
                if (objAsset.ParentId == rootAssetId) {
                    HierarchyWrapper wrap = new HierarchyWrapper();
                    wrap.Name = objAsset.Name;
                    wrap.ProductName = objAsset.Product2.Name;
                    wrap.ProductCode = objAsset.ProductCode;
                    wrap.ProductFamily = objAsset.ProductFamily;
                    wrap.children = findRelations(listAssets,objAsset.Id);
                    listWrap.add(wrap);
                }
            }
            if (listWrap.size() > 0)
                return listWrap;
            else 
                return null;
        } catch(Exception ex){
            
        }
        return null;
    }
}