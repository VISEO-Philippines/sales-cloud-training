trigger CaseTrigger on Case (before insert, after insert, before update, after update) {
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            CaseTriggerHandler.assignHighPriorityCaseToQueue(Trigger.new, null);
        } else if (Trigger.isUpdate) {
             CaseTriggerHandler.assignHighPriorityCaseToQueue(Trigger.new, Trigger.oldMap);
                    }
    } 
    else if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            
        } else if (Trigger.isUpdate) {
           
        }
    }

}