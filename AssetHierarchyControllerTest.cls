@isTest
public class AssetHierarchyControllerTest {
    @testSetup static void setupData(){        
        List<Account> accList = new List<Account> {
            	new Account(Name='HDFC'),
                new Account(Name='ManapuramFinance')
          };
        insert accList;  
    }
    
    @isTest
    static void testFetchAccountAssetHierarchy() {
        Test.startTest();
        Account acct = [SELECT Id from Account where Name='HDFC' LIMIT 1];
        Asset asst = new Asset(Name='HDFC Insurance',AccountId = acct.Id);
        insert asst;
        List<Asset> assetList = [Select id,ParentId from Asset];
        String parentId = assetList[0].ParentId;
        Asset childAsset = new Asset(Name='HDFC Life Insurance',ParentId=parentId,AccountId=acct.Id);
        insert childAsset;
        Asset childAst = [Select id,ParentId from Asset where Name='HDFC Life Insurance'];
        String gchildAstId = childAst.id;
        Asset gchildAsset = new Asset(Name='HDFC Life Limited Pay Insurance',ParentId=gchildAstId,AccountId=acct.Id);
        insert gchildAsset;
        AssetHierarchyController.fetchAccountAssetHierarchy(acct.Id);
        System.assert(AssetHierarchyController.fetchAccountAssetHierarchy(acct.Id).size()>0,true);
        Test.stopTest();
    }
}