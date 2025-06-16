trigger OpportunityTrigger on Opportunity (after insert, after update) {

    if(trigger.isAfter && trigger.isInsert){
        OpportunityTriggerHandler.createOpportunityContactRole(Trigger.new);
    }
    
}