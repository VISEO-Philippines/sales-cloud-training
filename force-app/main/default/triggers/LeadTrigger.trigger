trigger LeadTrigger on Lead (after update, after insert) {

    if(trigger.isAfter && trigger.isUpdate){
        LeadTriggerHandler.convertHotWebLeads(Trigger.new);
        LeadTriggerHandler.checkLeadsIfConverted(Trigger.new, Trigger.oldMap);
    }

    if(trigger.isAfter && trigger.isInsert){
        LeadTriggerHandler.convertHotWebLeads(Trigger.new);
        LeadTriggerHandler.checkLeadsIfConverted(Trigger.new, Trigger.oldMap);
    }

}