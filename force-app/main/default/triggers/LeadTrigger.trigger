trigger LeadTrigger on Lead (after insert, after update) {
    // US-1
    if(Trigger.isAfter && Trigger.isInsert) {
        LeadTriggerHandler.convertLeads(Trigger.new);
    }

    // US-3
    if(!Test.isRunningTest() && Trigger.isAfter && Trigger.isUpdate) {
        LeadTriggerHandler.handleConvertedFromLead(Trigger.new, Trigger.oldMap);
    }
}