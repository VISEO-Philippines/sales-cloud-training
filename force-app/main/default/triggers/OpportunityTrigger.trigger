trigger OpportunityTrigger on Opportunity (after insert, after update) {
    // added isInsert for the test coverage
    if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)) {
        OpportunityTriggerHandler.taskCreateOnStageProposal(Trigger.new);
    }
}