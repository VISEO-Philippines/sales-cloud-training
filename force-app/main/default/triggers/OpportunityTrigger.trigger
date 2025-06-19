trigger OpportunityTrigger on Opportunity (after insert, after update) {
    if(Trigger.isAfter && Trigger.isInsert) {
        OpportunityTriggerHandler.sendEmailNotification(Trigger.new, Trigger.oldMap);
    }
    if(Trigger.isAfter && Trigger.isUpdate) {
        OpportunityTriggerHandler.sendEmailNotification(Trigger.new, Trigger.oldMap);
    }
}