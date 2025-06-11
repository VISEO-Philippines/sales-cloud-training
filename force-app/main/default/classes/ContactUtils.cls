public with sharing class ContactUtils {
    public static Integer getOppCountForContactAccounts(List<Id> contactIds) {
        Integer totalOppCount = 0;

        // get accountIds associated to the contacts
        List<Contact> contactList = [SELECT Id, AccountId FROM Contact WHERE Id = :contactIds AND AccountId != null];
        
        Set<Id> accountIds = new Set<Id>();
        for (Contact con : contactList) {
            accountIds.add(con.AccountId);
        }

        // if no accounts are associated with the contacts, return 0
        if (accountIds.isEmpty()) {
            return totalOppCount;
        }
        
        // get the count of opportunities for each account
        // associated with the contacts
        Map<Id, Integer> accToOppCount  = new Map<Id, Integer>();
        for(Opportunity opp : [SELECT Id, AccountId FROM Opportunity WHERE AccountId IN :accountIds]) {
            if(!accToOppCount.containsKey(opp.AccountId)) {
                accToOppCount.put(opp.AccountId, 1);
            } else {
                accToOppCount.put(opp.AccountId, accToOppCount.get(opp.AccountId) + 1);
            }        
        }

        // sum up the opportunity counts for the accounts associated with the contacts
        for (Contact con : contactList) {
            if (accToOppCount.containsKey(con.AccountId)) {
                totalOppCount += accToOppCount.get(con.AccountId);
            } 
        }

        return totalOppCount;
    }
}