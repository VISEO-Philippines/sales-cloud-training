trigger OpportunityTrigger on Opportunity (after insert, after update,  before delete, before insert, before update) {
    if (Trigger.isBefore) {
        if (Trigger.isDelete) {
            OpportunityTriggerHandler.preventDeleteOfClosedWonOpportunities(Trigger.old);
        }
    }
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
