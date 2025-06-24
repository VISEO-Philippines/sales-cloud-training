trigger CaseTrigger on Case (before insert, before update) {

    if(Trigger.isBefore && Trigger.isInsert){
        CaseTriggerHandler.assignPriorityCasesToQueue(Trigger.new, Trigger.oldMap);
    }
    
    if(Trigger.isBefore && Trigger.isUpdate){
        CaseTriggerHandler.assignPriorityCasesToQueue(Trigger.new, Trigger.oldMap);
    }
}