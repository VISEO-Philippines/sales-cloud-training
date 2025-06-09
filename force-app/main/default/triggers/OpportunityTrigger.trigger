trigger OpportunityTrigger on Opportunity (after insert) {
    if(Trigger.isAfter && Trigger.isInsert) {
        OpportunityTriggerHandler.addPrimaryContactRole(Trigger.new);
    }
}