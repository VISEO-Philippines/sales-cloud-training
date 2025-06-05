trigger LeadTrigger on Lead (after update) {
    LeadTriggerHandler.handleConvertedFromLead(Trigger.new, Trigger.oldMap);
}