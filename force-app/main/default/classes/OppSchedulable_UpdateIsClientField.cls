public with sharing class OppSchedulable_UpdateIsClientField implements Schedulable {
    public void execute(SchedulableContext sc) {
        // This will run at midnight every day
        OppBatch_UpdateIsClientField accUpdate = new OppBatch_UpdateIsClientField();
        Database.executeBatch(accUpdate);
    }
}