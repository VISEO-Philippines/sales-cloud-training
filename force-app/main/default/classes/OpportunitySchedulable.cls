global with sharing class OpportunitySchedulable implements Schedulable {
     global void execute(SchedulableContext sc) {
        OpportunityScheduleHandler accUpdate = new OpportunityScheduleHandler();
        Database.executeBatch(accUpdate);
    }
}