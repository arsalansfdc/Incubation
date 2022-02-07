@isTest
public class AssetsControllerTest {
    @testSetup static void setupData(){        
        List<Account> accList = new List<Account> {
            	new Account(Name='HDFC'),
                new Account(Name='ManapuramFinance')
          };
        insert accList;  
    }
    
    @isTest
    static void testgetAllAssets() {
        test.startTest();
        Account acct = [SELECT Id from Account where Name='HDFC' LIMIT 1];
        Asset asst = new Asset(Name='HDFC Insurance',AccountId = acct.Id);
        insert asst;
        List<Asset> assetList = [Select id,ParentId from Asset];
        String parentId = assetList[0].ParentId;
        Asset childAsset = new Asset(Name='HDFC Life Insurance',ParentId=parentId,AccountId=acct.Id);
        insert childAsset;
        AssetsController.getAllAssets(acct.Id);
        System.assert(AssetsController.getAllAssets(acct.Id).size()>0,true);
        Test.stopTest();
    }
 
    @isTest
    static void testNoRelatedAssets() {
        Account acct = [SELECT Id from Account where Name='ManapuramFinance' LIMIT 1];
        AssetsController.getAllAssets(acct.Id);
        System.assertEquals(AssetsController.getAllAssets(acct.Id), null);
    }
}