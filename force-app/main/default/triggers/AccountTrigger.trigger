trigger AccountTrigger on Account (after insert) {
    if (!Test.isRunningTest() && Trigger.isAfter && Trigger.isInsert) {
        AccountTriggerHandler.createDefaultContactAndTaskForAccounts(Trigger.new);
    }
}
