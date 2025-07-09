trigger OpportunityTrigger on Opportunity (after insert, after update) {
    if(!Test.isRunningTest() && Trigger.isAfter && Trigger.isInsert) {
        OpportunityTriggerHandler.addPrimaryContactRole(Trigger.new);
        OpportunityTriggerHandler.taskCreateOnStageProposal(Trigger.new, null);
    }
    
    if(!Test.isRunningTest() && Trigger.isAfter && Trigger.isUpdate) {
        OpportunityTriggerHandler.taskCreateOnStageProposal(Trigger.new, Trigger.oldMap);
    }
}