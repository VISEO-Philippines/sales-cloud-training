trigger ContactTrigger on Contact (after delete) {
    if(Trigger.isAfter && Trigger.isDelete) {
        ContactTriggerHandler.publishContactDeletion(Trigger.old);
    }
}