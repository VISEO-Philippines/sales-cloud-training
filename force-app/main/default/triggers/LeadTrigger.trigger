trigger LeadTrigger on SOBJECT (before insert) {

    if(trigger.isAfter && trigger.isUpdate){
        LeadTriggerHandler.convertHotWebLeads(Trigger.new);
    }

    if(trigger.isAfter && trigger.isInsert){
        LeadTriggerHandler.convertHotWebLeads(Trigger.new);
    }

}