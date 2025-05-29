trigger PrimaryContactRoleOnOpportunityTrigger on Opportunity (after insert, after update) {
    if((Trigger.isAfter) && (Trigger.isInsert) || (Trigger.isUpdate)){
        PrimaryContactRoleOnOpportunityHandler.createOpportunityContactRole(Trigger.new);
    }
}