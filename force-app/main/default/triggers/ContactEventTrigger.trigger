trigger ContactEventTrigger on Contact_Delete_Event__e (after insert) {
    if(Trigger.isAfter && Trigger.isInsert) {
        ContactEventTriggerHandler.publishLogContactCreation(Trigger.new);
    }
}