global with sharing class OpportunityBatch implements Database.Batchable<SObject> {
    global Database.QueryLocator start(Database.BatchableContext BC) { 
        return Database.getQueryLocator([SELECT Id, StageName, AccountId FROM Opportunity WHERE StageName = 'Closed Won']);
    }

    global void execute(Database.BatchableContext bc, List<Opportunity> oppList) {
        Map<Id, Account> accToUpdateMap = new Map<Id, Account>();

        for (Opportunity opp : oppList) {
            if (opp.AccountId != null) {
                if(accToUpdateMap.containsKey(opp.AccountId)) {
                    continue; // Skip if already processed
                }
                accToUpdateMap.put(opp.AccountId, new Account(Id = opp.AccountId, Is_Client__c = true));
            }
        }

        if (!accToUpdateMap.isEmpty()) {
            update accToUpdateMap.values();
        }
    }

    global void finish(Database.BatchableContext BC) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] {'mico.calingasan@viseo.com'});
        mail.setSubject('Batch Job Complete');
        mail.setPlainTextBody('The batch job has completed successfully.');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}