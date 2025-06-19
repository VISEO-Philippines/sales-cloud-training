trigger CaseTrigger on Case (before insert, before update) {
    if (Trigger.isBefore && Trigger.isInsert) {
        CaseTriggerHandler.caseAssignHighPriority(Trigger.new, Trigger.oldMap);
    }

    if(Trigger.isBefore && Trigger.isUpdate) {
        CaseTriggerHandler.caseAssignHighPriority(Trigger.new, Trigger.oldMap);
    }
}