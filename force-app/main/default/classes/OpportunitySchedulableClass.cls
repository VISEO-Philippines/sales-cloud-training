global with sharing class OpportunitySchedulableClass implements Schedulable {
     global void execute(SchedulableContext sc) {
        OpportunityScheduleHandler accUpdate = new OpportunityScheduleHandler();
        Database.executeBatch(accUpdate);
        
        System.debug('Scheduled job executed successfully.');
    }
}