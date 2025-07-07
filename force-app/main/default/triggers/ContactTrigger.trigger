trigger ContactTrigger on Contact (after delete) {
    if(Trigger.isAfter && Trigger.isDelete)
    {
        ContactTriggerHelper.logDeletedContact(Trigger.old);
    }
}
