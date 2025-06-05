trigger ContactTrigger on Contact (after insert) {
    if(Trigger.isAfter && Trigger.isInsert) {
        AccountTriggerHandler.relateTaskToContact(Trigger.new);
    }
}