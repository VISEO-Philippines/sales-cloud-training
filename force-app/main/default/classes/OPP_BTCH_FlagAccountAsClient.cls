global class OPP_BTCH_FlagAccountAsClient implements Database.Batchable<SObject> {

    private static final String CLOSED_WON_STAGE_NAME = 'Closed Won';

    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator([
            SELECT Id, AccountId 
            FROM Opportunity 
            WHERE StageName = :CLOSED_WON_STAGE_NAME
                  AND Account.Is_Client__c = false
                  AND AccountId != null
        ]);
    }

    global void execute(Database.BatchableContext BC, List<SObject> scope) {
        Set<Id> accountIdsToUpdate = new Set<Id>();
        for (Opportunity opp : (List<Opportunity>) scope) {
            if (opp.AccountId != null) {
                accountIdsToUpdate.add(opp.AccountId);
            }
        }

        if (accountIdsToUpdate.isEmpty()) return;

        List<Account> accountsToUpdate = new List<Account>();

        for (Account acc : [SELECT Id FROM Account WHERE Id IN :accountIdsToUpdate]) {
            acc.Is_Client__c = true;
            accountsToUpdate.add(acc);
        }

        try {
            if (!accountsToUpdate.isEmpty()) {
                Database.SaveResult[] results = Database.update(accountsToUpdate, false);
                for (Database.SaveResult result : results) {
                    if (!result.isSuccess()) {
                        for (Database.Error error : result.getErrors()) {
                            System.debug('Error updating account: ' + error.getMessage());
                        }
                    }
                }
            }
        } catch (DmlException e) {
            System.debug('DML exception occurred: ' + e.getMessage());
        }
    }

    global void finish(Database.BatchableContext BC) {
        System.debug('OPP_BTCH_FlagAccountAsClient has completed.');
    }
}
