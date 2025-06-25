trigger LeadTrigger on Lead (after Insert, after Update) {

    if(!Test.isRunningTest() && Trigger.isAfter && Trigger.isUpdate){
        LeadTriggerHandler.convertHotWebLeads(Trigger.new, Trigger.oldMap);
    }

    if(!Test.isRunningTest() && Trigger.isAfter && Trigger.isInsert){
        LeadTriggerHandler.convertHotWebLeads(Trigger.new, null);
    }

}