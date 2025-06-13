trigger OpportunityTrigger on Opportunity (before delete) {
    if(Trigger.isBefore && Trigger.isDelete) {
        OpportunityTriggerHandler.validateDelete(Trigger.old);
    }
}