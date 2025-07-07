trigger CaseTrigger on Case (before insert, before update) {
    if (!Test.isRunningTest() && Trigger.isBefore && Trigger.isInsert) {
        CaseTriggerHandler.caseAssignHighPriority(Trigger.new, null);
    }

    if(!Test.isRunningTest() && Trigger.isBefore && Trigger.isUpdate) {
        CaseTriggerHandler.caseAssignHighPriority(Trigger.new, Trigger.oldMap);
    }
}