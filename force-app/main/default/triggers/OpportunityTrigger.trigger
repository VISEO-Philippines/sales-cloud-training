trigger OpportunityTrigger on Opportunity (after insert) {

    if(!Test.isRunningTest() && Trigger.isAfter && Trigger.isInsert){
        OpportunityTriggerHandler.createOpportunityContactRole(Trigger.new);
    }
    
}