trigger LeadTrigger on Lead (after insert, after update) {
	if (Trigger.isAfter && (Trigger.isUpdate || Trigger.isInsert)) {
        LeadConverterHandler.convertHotWebLeads(Trigger.new);
    }
}