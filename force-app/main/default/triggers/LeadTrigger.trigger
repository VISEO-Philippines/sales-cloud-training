trigger LeadTrigger on Lead (after insert, after update) {
	if (Trigger.isAfter && Trigger.isUpdate ) {
        LeadTriggerHandler.convertHotWebLeads(Trigger.new);
    }
    if (Trigger.isAfter &&  Trigger.isInsert) {
        LeadTriggerHandler.convertHotWebLeads(Trigger.new);
    }
}