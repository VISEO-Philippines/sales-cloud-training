trigger LeadTrigger on Lead (after insert, after update) {
	if(!Test.isRunningTest() &&  Trigger.isAfter &&Trigger.isUpdate ){
        LeadTriggerHandler.convertHotWebLeads(Trigger.new, Trigger.oldMap);
    }
  if (!Test.isRunningTest() && Trigger.isAfter && Trigger.isInsert) {
        LeadTriggerHandler.convertHotWebLeads(Trigger.new, null);
    }
}