global with sharing class OpportunitySchedulable implements Schedulable {
    global void execute(SchedulableContext sc) {
        OpportunityBatch accUpdate = new OpportunityBatch();
        Database.executeBatch(accUpdate);
    }
}