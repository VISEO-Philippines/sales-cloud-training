global class OpportunitySchedulable implements Schedulable {
    
    global void execute(SchedulableContext sc){
        
        OpportunityBatchHandler clientAccounts = new OpportunityBatchHandler();
        Database.executeBatch(clientAccounts);    
    }
}