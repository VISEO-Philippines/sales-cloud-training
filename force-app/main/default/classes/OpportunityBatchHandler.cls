public class OpportunityBatchHandler implements Database.Batchable<SObject> {
    
    public Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator('SELECT Id, AccountId, Account.Is_Client__c, IsWon FROM Opportunity WHERE IsWon = TRUE');
    }
    
    public void execute(Database.BatchableContext bc, List<Opportunity> oppClientList){
		
		List<Account> accountToUpdate = new List<Account>();
		Set<Id> accountIds = new Set<Id>();
        
        for(Opportunity opp : oppClientList){
            if(!accountIds.contains(opp.AccountId)){
				accountIds.add(opp.AccountId);
                Account acc = new Account(
                Id = opp.AccountId,
                Is_Client__c = true
                );
                    accountToUpdate.add(acc);
            }
        }
        update accountToUpdate;
    }
    
    public void finish(Database.BatchableContext bc){
        System.debug('Batch Job Completed');
    }

}