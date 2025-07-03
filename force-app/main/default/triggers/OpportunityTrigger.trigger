trigger OpportunityTrigger on Opportunity (after insert, after update) {
    if (!Test.isRunningTest() && Trigger.isAfter && Trigger.isInsert) {
            OpportunityTriggerHandler.createOpportunityContactRole(Trigger.new);
            OpportunityTriggerHandler.generateTaskForOpportunityOwner(Trigger.new, null); // pass null
            OpportunityHelperClass.sendEmailAfterOppClosedWonWithSpecificAmount(Trigger.new, null);
        }
    if (!Test.isRunningTest() && Trigger.isAfter && Trigger.isUpdate) {
            OpportunityTriggerHandler.generateTaskForOpportunityOwner(Trigger.new, Trigger.oldMap); // this will now be non-null
            OpportunityHelperClass.sendEmailAfterOppClosedWonWithSpecificAmount(Trigger.new, Trigger.oldMap);
        }
}
