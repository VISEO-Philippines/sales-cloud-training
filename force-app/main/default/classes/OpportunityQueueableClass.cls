public class OpportunityQueueableClass implements Queueable {
    public void execute(QueueableContext context) {
        String cronExp = '0 0 0 ? * * *'; // daily run at midnight
        OpportunitySchedulableClass scheduleJob = new OpportunitySchedulableClass();

        String jobName = 'DailyOpportunityUpdate_' + Datetime.now().getTime();
        System.schedule(jobName, cronExp, scheduleJob);
    }
}