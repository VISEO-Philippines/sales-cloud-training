global class OPP_BTCH implements Database.Batchable<SObject> {

    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator([
            SELECT Id, Is_Client__c, Opportunity_Status__c FROM Account
        ]);
    }
    global void execute(Database.BatchableContext BC, List<Account> accountsToUpdate) {
        // Map AccountId -> List<Opportunity>
        Map<Id, List<Opportunity>> accountOppMap = new Map<Id, List<Opportunity>>();

        // Query related Opportunities
        List<Opportunity> opps = [
            SELECT Id, AccountId, StageName
            FROM Opportunity
            WHERE AccountId IN :accountsToUpdate
        ];

        //Map for AccountId -> List<Opportunity>
        for (Opportunity opp : opps) {
            if (!accountOppMap.containsKey(opp.AccountId)) {
                accountOppMap.put(opp.AccountId, new List<Opportunity>());
            }
            accountOppMap.get(opp.AccountId).add(opp);
        }

        // Process each account
        for (Account acc : accountsToUpdate) {
            List<Opportunity> relatedOpps = accountOppMap.get(acc.Id);

            Integer closedWonCount = 0;
            Integer openCount = 0;
            String imageColor = 'Red'; // default

            if (relatedOpps != null && !relatedOpps.isEmpty()) {
                for (Opportunity opp : relatedOpps) {
                    if (opp.StageName == 'Closed Won') {
                        closedWonCount++;
                    } else if (opp.StageName != 'Closed Won' && opp.StageName != 'Closed Lost') {
                        openCount++;
                    }
                }

                if (closedWonCount > 0) {
                    acc.Opportunity_Status__c = 'Green';
                    acc.Is_Client__c = true;
                } else if (openCount > 0) {
                    acc.Opportunity_Status__c = 'Yellow';
                    acc.Is_Client__c = false;
                } else {
                    acc.Opportunity_Status__c = 'Red';
                    acc.Is_Client__c = false;
                }
            } else {
                acc.Opportunity_Status__c = 'Red';
                acc.Is_Client__c = false;
            }
        }

        // Update directly modified list
        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }

    global void finish(Database.BatchableContext BC) {
    }
}
