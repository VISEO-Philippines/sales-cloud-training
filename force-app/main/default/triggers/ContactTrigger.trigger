trigger ContactTrigger on Contact (after delete) {
    if(!Test.isRunningTest() && Trigger.isAfter && Trigger.isDelete) {
        ContactTriggerHandler.publishEventContactDeletion(Trigger.old);
    }
}