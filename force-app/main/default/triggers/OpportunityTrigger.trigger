trigger OpportunityTrigger on Opportunity (after insert, after update) {
    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            OpportunityTriggerHandler.createOpportunityContactRole(Trigger.new);
            OpportunityTriggerHandler.generateTaskForOpportunityOwner(Trigger.new, null);
            OpportunityHelperClass.sendEmailAfterOppClosedWonWithSpecificAmount(Trigger.new);
        }

        if (Trigger.isUpdate) {
            OpportunityTriggerHandler.generateTaskForOpportunityOwner(Trigger.new, Trigger.oldMap);
            OpportunityHelperClass.sendEmailAfterOppClosedWonWithSpecificAmount(Trigger.new);
        }
    }
}
