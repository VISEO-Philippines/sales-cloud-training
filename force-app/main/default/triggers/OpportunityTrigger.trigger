trigger OpportunityTrigger on Opportunity (after insert, after update) {
    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            OpportunityTriggerHandler.createOpportunityContactRole(Trigger.new);
            OpportunityTriggerHandler.generateTaskForOpportunityOwner(Trigger.new, null); // pass null
        }

        if (Trigger.isUpdate) {
            OpportunityTriggerHandler.generateTaskForOpportunityOwner(Trigger.new, Trigger.oldMap); // this will now be non-null
        }
    }
}
