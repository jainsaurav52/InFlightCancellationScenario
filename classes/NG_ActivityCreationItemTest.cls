@isTest
public class NG_ActivityCreationItemTest {

    @testSetup
    static void setupMethod(){
        Account parentAccount = NG_SomTestRecordUtilities.getAccount();
        insert parentAccount;
        Account thisAccount = NG_SomTestRecordUtilities.getAccount();
        thisAccount.ParentId = parentAccount.Id;
        insert thisAccount;
        
        Order thisOrder = NG_SomTestRecordUtilities.getOrder(thisAccount);
        
        insert thisOrder;

        vlocity_cmt__OrchestrationPlan__c thisOrchestrationPlan = NG_SomTestRecordUtilities.getOrchestrationPlan();
        thisOrchestrationPlan.vlocity_cmt__OrderId__c = thisOrder.Id;
        insert thisOrchestrationPlan;
        
        vlocity_cmt__OrchestrationItem__c orchItemTemp = NG_SomTestRecordUtilities.getOrchestrationItem(thisOrchestrationPlan);
        orchItemTemp.name = 'NG Sample Item';
        insert orchItemTemp;
        
        vlocity_cmt__OrchestrationItem__c orchItemPrev = NG_SomTestRecordUtilities.getOrchestrationItem(thisOrchestrationPlan);
        orchItemPrev.name = 'NG Update CPE Asset';
        insert orchItemPrev;
        
        vlocity_cmt__OrchestrationItem__c orchItem = NG_SomTestRecordUtilities.getOrchestrationItem(thisOrchestrationPlan);
        orchItem.name = 'NG CPE Activity Creation';
        insert orchItem;
        
        vlocity_cmt__OrchestrationDependency__c orchDepPrev = new vlocity_cmt__OrchestrationDependency__c();
        orchDepPrev.vlocity_cmt__DependsOnItemId__c = orchItemPrev.id;
        orchDepPrev.vlocity_cmt__OrchestrationItemId__c = orchItem.id;
        insert orchDepPrev;
        
        vlocity_cmt__OrchestrationDependency__c orchDep = new vlocity_cmt__OrchestrationDependency__c();
        orchDep.vlocity_cmt__DependsOnItemId__c = orchItem.id;
        orchDep.vlocity_cmt__OrchestrationItemId__c = orchItemTemp.Id;
        insert orchDep;
        
	        

        thisOrder.vlocity_cmt__OrchestrationPlanId__c = thisOrchestrationPlan.Id;
        update thisOrder;

        vlocity_cmt__FulfilmentRequest__c thisFulfilmentRequest = NG_SomTestRecordUtilities.getFulfilmentRequest(thisAccount, thisOrder, thisOrchestrationPlan);
        thisFulfilmentRequest.vlocity_cmt__OrderId__c = thisOrder.Id;
        insert thisFulfilmentRequest;

        vlocity_cmt__FulfilmentRequestLine__c thisFulfilmentRequestLine = NG_SomTestRecordUtilities.getFulfilmentRequestLine();
        thisFulfilmentRequestLine.vlocity_cmt__FulfilmentRequestID__c   = thisFulfilmentRequest.Id;
		insert thisFulfilmentRequestLine;
        
    }
    
    @isTest
    static void createActivityItemsTest(){
        Map<String, Object> input = new Map<String,Object>();
        Map<String, Object> output = new Map<String,Object>();
        Map<String, Object> options = new Map<String, Object>();
        vlocity_cmt__FulfilmentRequestLine__c frl = [select id from vlocity_cmt__FulfilmentRequestLine__c limit 1];
        vlocity_cmt__OrchestrationItem__c orchItem = [select id,name from vlocity_cmt__OrchestrationItem__c where name = 'NG CPE Activity Creation' limit 1];
        
        input.put('FRLStatus','Activity Created');
        input.put('cpeList',2);
        input.put('FrlId',frl.Id);
        input.put('orchItemId',orchItem.Id);
        input.put('orchItemName',orchItem.Name);
        
        new NG_ActivityCreationItem().invokeMethod('createActivityItems',input,output,options);
    }
}