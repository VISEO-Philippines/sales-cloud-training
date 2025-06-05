trigger OpportunityTrigger on Opportunity (before insert, before update, after insert, after update) {
    if(Trigger.isAfter && Trigger.isUpdate) {
        System.enqueueJob(new OpportunityQueueableClass());
    }
}