trigger LeadTrigger on Lead (after update) {

    if(trigger.isAfter && trigger.isUpdate){
        LeadTriggerHandler.convertHotWebLeads(Trigger.new);
    }

}