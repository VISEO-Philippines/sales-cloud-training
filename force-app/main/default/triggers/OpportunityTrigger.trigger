trigger OpportunityTrigger on Opportunity (after insert, after update) {

    if(trigger.isAfter && trigger.isInsert){
        OpportunityTriggerHandler.createOpportunityContactRole(Trigger.new);
        OpportunityTriggerHandler.createTaskWhenOppStageProposalPriceQuote(Trigger.new, Trigger.oldMap);
    }

    if(trigger.isAfter && trigger.isUpdate){
        OpportunityTriggerHandler.createOpportunityContactRole(Trigger.new);
        OpportunityTriggerHandler.createTaskWhenOppStageProposalPriceQuote(Trigger.new, Trigger.oldMap);
    }
}