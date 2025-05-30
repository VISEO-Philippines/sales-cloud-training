public with sharing class OpportunityTriggerHandler {
    public static void createOpportunityContactRole(List<Opportunity> opps) {
        // Map of AccountId to list of Contacts
        Map<Id, List<Contact>> accountContactsMap = new Map<Id, List<Contact>>();
        Set<Id> accountIds = new Set<Id>();

        for (Opportunity opp : opps) {
            if (opp.AccountId != null) {
                accountIds.add(opp.AccountId);
            }
        }   
    
        if (accountIds.isEmpty()) return;
            // soql Query contacts for all accounts in one go
            for (List<Contact> contacts : [SELECT Id, AccountId FROM Contact WHERE AccountId IN :accountIds]) {
                if (!accountContactsMap.containsKey(contacts[0].AccountId)) {
                    accountContactsMap.put(contacts[0].AccountId, new List<Contact>());
                }
                accountContactsMap.get(contacts[0].AccountId).addAll(contacts);
            }

        List<OpportunityContactRole> oppContactRolesToInsert = new List<OpportunityContactRole>();
        for (Opportunity opp : opps) {
            if (opp.AccountId != null && accountContactsMap.containsKey(opp.AccountId)) {
                List<Contact> contacts = accountContactsMap.get(opp.AccountId);
                if (!contacts.isEmpty()) {
                    //randomly select one contact from the list
                    Integer randIndex = (Integer)(Math.random() * contacts.size());
                    Contact selectedContact = contacts[randIndex];
                    System.debug('Selected Contact: ' + selectedContact);
                    // Create OpportunityContactRole record
                    oppContactRolesToInsert.add(new OpportunityContactRole(
                        OpportunityId = opp.Id,
                        ContactId = selectedContact.Id,
                        IsPrimary = true
                    ));
                    System.debug('OpportunityContactRole:' + oppContactRolesToInsert);
                }
            }
        }

        if (!oppContactRolesToInsert.isEmpty()) {
            insert oppContactRolesToInsert;
        }
    }
}