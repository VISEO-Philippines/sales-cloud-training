trigger ContactTrigger on Contact (after delete) {
    if(Trigger.isAfter && Trigger.isDelete) {
        ContactTriggerHandler.publishEventContactDeletion(Trigger.old);
    }
}