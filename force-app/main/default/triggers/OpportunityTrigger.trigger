trigger OpportunityTrigger on Opportunity (after insert, after update) {
    if(!Test.isRunningTest() && Trigger.isAfter && Trigger.isInsert) {
        OpportunityTriggerHandler.sendEmailNotification(Trigger.new, null);
    }
    if(!Test.isRunningTest() && Trigger.isAfter && Trigger.isUpdate) {
        OpportunityTriggerHandler.sendEmailNotification(Trigger.new, Trigger.oldMap);
    }
}