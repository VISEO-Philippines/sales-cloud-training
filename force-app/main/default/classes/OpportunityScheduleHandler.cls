global class OpportunityScheduleHandler implements Database.Batchable<SObject> {

    public integer recordCount = 0;
    
    global Database.QueryLocator start(Database.BatchableContext BC) { 
        return Database.getQueryLocator([SELECT Id, StageName, AccountId FROM Opportunity]);
    }

    global void execute(Database.BatchableContext BC, List<Opportunity> oppList) {
        List<Account> accToUpdateList = new List<Account>();

        for (Opportunity opp : oppList) {
            if (opp.StageName == 'Closed Won') {
                accToUpdateList.add(new Account(Id = opp.AccountId, Is_Client__c = true));            
            }
        }
        update accToUpdateList;
        recordCount = recordCount + accToUpdateList.size();
    }

    global void finish(Database.BatchableContext BC) {
        System.debug('Batch job completed successfully. Total records processed: ' + recordCount);
    }
    
}