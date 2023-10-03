/*
*****************************************************************************************************************************
Apex Class Name    : NG_ActivityCreationItem
Created Date       : 26/09/23
@description       : This class is used for handling mutiple activity creation callouts as per CPEs in the order
@author            : Saurav Jain

Modification Log:
Ver   Date             Author                               Modification
------------------------------------------------------------------------------------------------------------------------------
1.0   26/09/23   Saurav Jain                        Initial Version
*****************************************************************************************************************************
*/

global class NG_ActivityCreationItem implements vlocity_cmt.VlocityOpenInterface{

    public static final string ORCHITEMNAME_CONST = 'NG CPE Activity Creation';
    public static final string METHODNAME_CONST = 'createActivityItems';
    public static final string FRLSTATUS_CONST = 'FRLStatus';
    public static final string FRLID_CONST = 'FrlId';
    public static final string ORCHITEMID_CONST = 'orchItemId';
    public static final string CPELIST_CONST = 'cpeList';
    public static final string ORCHNAME_CONST = 'orchItemName';
    
    public Boolean invokeMethod(String methodName, Map<String, Object> inputs, Map<String, Object> output, Map<String, Object> options){
        if (methodName.equalsIgnoreCase(METHODNAME_CONST))
        {
            String frlStatus = String.valueOf(inputs.get(FRLSTATUS_CONST));
            String frlId = String.valueOf(inputs.get(FRLID_CONST));
            String orchItemId = String.valueOf(inputs.get(ORCHITEMID_CONST));
            Integer cpeList = Integer.valueOf(inputs.get(CPELIST_CONST));
            String orchItemName = String.valueOf(inputs.get(ORCHNAME_CONST));
            createActivityItems(orchItemId, frlId, frlStatus, cpeList, orchItemName);
        }
        return true;
    }
    // method to create Activity items for CPE devices
    public void createActivityItems(String orchId, String frlId, String frlStatus, Integer cpeList, String orchItemName){
        List<Sobject> tempList = new List<SObject>();
        // updating TMF_Notification_Status__c for each CPE whose activity creation is sent
        vlocity_cmt__FulfilmentRequestLine__c frl = [select id,TMF_Notification_Status__c from vlocity_cmt__FulfilmentRequestLine__c where id =: frlId];
        frl.TMF_Notification_Status__c = frlStatus;
        tempList.add(frl);
        // exceute this block only for the first CPE item using orch item name
        if(orchItemName.equalsIgnoreCase(ORCHITEMNAME_CONST)){
            vlocity_cmt__OrchestrationItem__c orch = [select id,vlocity_cmt__OrchestrationPlanId__c, Name, vlocity_cmt__OrchestrationQueueId__c, vlocity_cmt__OrchestrationItemType__c,
                                                      vlocity_cmt__SystemInterfaceId__c, vlocity_cmt__OrchestrationItemDefinitionId__c, vlocity_cmt__ErrorQueueId__c, vlocity_cmt__FulfilmentRequestLineId__c,
                                                      vlocity_cmt__OrderFulfilmentRequest__c, (select id,name,vlocity_cmt__DependsOnItemId__c, vlocity_cmt__OrchestrationDependencyDefinitionId__c,
                                                                                               vlocity_cmt__OrchestrationItemId__c, vlocity_cmt__Order__c, vlocity_cmt__Plan__c from vlocity_cmt__OrchestrationDependencies__r limit 1)
                                                      from vlocity_cmt__OrchestrationItem__c where id =: orchId limit 1];
            
            
            List<vlocity_cmt__OrchestrationItem__c> itemList = new List<vlocity_cmt__OrchestrationItem__c>();
            vlocity_cmt__OrchestrationItem__c tempPrevOrch = orch;
            vlocity_cmt__OrchestrationDependency__c depItemFinal = [select id,name,vlocity_cmt__DependsOnItemId__c from vlocity_cmt__OrchestrationDependency__c where vlocity_cmt__DependsOnItemId__c =: orch.id limit 1];
            
            
            
            // create new Activity items required for CPE devices
            for(integer i = 2; i <= cpeList; i++){
                vlocity_cmt__OrchestrationItem__c tempOrch = orch.clone();
                tempOrch.name = tempOrch.name + ' ' + i;
                itemList.add(tempOrch);
            }
            insert itemList;
            // link all the items created above via vlocity_cmt__OrchestrationDependency__c
            for(vlocity_cmt__OrchestrationItem__c tempOrch : itemList){
                vlocity_cmt__OrchestrationDependency__c tempDep = orch.vlocity_cmt__OrchestrationDependencies__r[0].clone();
                tempDep.vlocity_cmt__DependsOnItemId__c = tempPrevOrch.id;
                tempDep.vlocity_cmt__OrchestrationItemId__c = tempOrch.id;
                tempPrevOrch = tempOrch;
                tempList.add(tempDep);
            }
            
            // update the last dependent item
            depItemFinal.vlocity_cmt__DependsOnItemId__c = tempPrevOrch.id;
            tempList.add(depItemFinal);
            
            
        }
        upsert tempList;
    
    }
}