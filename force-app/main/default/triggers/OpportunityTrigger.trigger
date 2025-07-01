trigger OpportunityTrigger on Opportunity (after insert, after update) {
    if(!Test.isRunningTest() && Trigger.isAfter && Trigger.isInsert) {
        OpportunityTriggerHandler.taskCreateOnStageProposal(Trigger.new, Trigger.oldMap);
    }
    
    if(!Test.isRunningTest() && Trigger.isAfter && Trigger.isUpdate) {
        OpportunityTriggerHandler.taskCreateOnStageProposal(Trigger.new, Trigger.oldMap);
    }
}