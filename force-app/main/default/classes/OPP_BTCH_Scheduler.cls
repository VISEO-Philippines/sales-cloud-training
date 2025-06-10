global class OPP_BTCH_Scheduler implements Schedulable {
    global void execute(SchedulableContext SC) {
        OPP_BTCH batch = new OPP_BTCH();
        Database.executeBatch(batch, 200); // 200 is the batch size
    }
}
