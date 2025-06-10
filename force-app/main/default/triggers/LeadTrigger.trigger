trigger LeadTrigger on Lead (after insert, after update) {
	if (Trigger.isAfter && Trigger.isUpdate) {
        LeadTriggerHandler.convertHotWebLeads(Trigger.new);
    }
    if ( Trigger.isAFter && Trigger.isInsert){
        LeadTriggerHandler.convertHotWebLeads(Trigger.new);
    }
}