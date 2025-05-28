trigger AddPrimaryContactRoleTrigger on Opportunity (after insert) {
    
    // check if running after insert
    if(Trigger.isAfter && Trigger.isInsert) {
        AddPrimaryContactRoleHandler.AddPrimaryContactRole(Trigger.new);
    }
}