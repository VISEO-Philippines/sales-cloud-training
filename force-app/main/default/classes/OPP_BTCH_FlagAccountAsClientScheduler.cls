global class OPP_BTCH_FlagAccountAsClientScheduler implements Schedulable {
    global void execute(SchedulableContext SC) {
        OPP_BTCH_FlagAccountAsClient batch = new OPP_BTCH_FlagAccountAsClient();
        Database.executeBatch(batch, 200); // 200 is the batch size
        //Scheduler to run batch class OPP_BTCH_FlagAccountAsClientOnWon every day at 12 AM
        
    }
}
