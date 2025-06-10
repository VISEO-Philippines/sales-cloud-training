trigger OpportunityTrigger on Opportunity (after insert, after update) {
    if(Trigger.isAfter && Trigger.isInsert) {
        OpportunityTriggerHandler.taskCreateOnStageProposal(Trigger.new, Trigger.oldMap);
    }
    
    if(Trigger.isAfter && Trigger.isUpdate) {
        OpportunityTriggerHandler.taskCreateOnStageProposal(Trigger.new, Trigger.oldMap);
    }
}