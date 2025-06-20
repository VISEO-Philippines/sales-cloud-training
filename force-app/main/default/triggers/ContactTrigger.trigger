trigger ContactTrigger on Contact (before delete) {
    if(Trigger.isBefore && Trigger.isDelete)
    {
        ContactTriggerHelper.logDeletedContact(Trigger.old);
    }
}
