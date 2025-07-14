trigger OpportunityTrigger on Opportunity (after insert, after update, before delete) {

    if(trigger.isAfter && trigger.isInsert){
        OpportunityTriggerHandler.createOpportunityContactRole(Trigger.new);
        OpportunityTriggerHandler.createTaskWhenOppStageProposalPriceQuote(Trigger.new, Trigger.oldMap);
        OpportunityHelper.sendAlertForWonOpps(Trigger.new);
    }

    if(trigger.isAfter && trigger.isUpdate){
        OpportunityTriggerHandler.createOpportunityContactRole(Trigger.new);
        OpportunityTriggerHandler.createTaskWhenOppStageProposalPriceQuote(Trigger.new, Trigger.oldMap);
        OpportunityHelper.sendAlertForWonOpps(Trigger.new);
    }

    if(trigger.isBefore && trigger.isDelete){
        OpportunityTriggerHandler.preventDeleteOfWonOpps(Trigger.old);
    }
}