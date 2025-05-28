trigger OpportunityTrigger on Opportunity (after insert) {

    if(trigger.isAfter && trigger.isInsert){
        OpportunityTriggerHandler.createOpportunityContactRole(Trigger.new);
    }

}