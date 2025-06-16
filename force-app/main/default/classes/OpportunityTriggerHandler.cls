public with sharing class OpportunityTriggerHandler {
    public static void createOpportunityContactRole(List<Opportunity> opportunities) {
        Set<Id> relatedAccountIds = new Set<Id>();
        List<Opportunity> oppList = new List<Opportunity>();
        
        for (Opportunity opp : opportunities) {
            if (opp.AccountId != null) {
                relatedAccountIds.add(opp.AccountId);
                oppList.add(opp);
            }
        }
        
        // Map to store the related account's first contact
        Map<Id, Contact> accountIdToContactsMap = new Map<Id, Contact>();

        // Query the contacts of each account (1 contact per account)
        for (Account acc : [SELECT Id, (SELECT Id FROM Contacts LIMIT 1) FROM Account WHERE Id IN :relatedAccountIds]) {
            for (Contact con : acc.Contacts) {
                accountIdToContactsMap.put(acc.Id, con);
            }
        }

        // Assign OpportunityContactRoles to Opps
        List<OpportunityContactRole> newOppConRole = new List<OpportunityContactRole>();
        
        for(Opportunity opp : oppList) {
            if(accountIdToContactsMap.containsKey(opp.AccountId)) {
                newOppConRole.add(new OpportunityContactRole(
                    OpportunityId = opp.Id,
                    ContactId =  accountIdToContactsMap.get(opp.AccountId).Id,
                    IsPrimary = true
                ));
            }
        }

        if (!newOppConRole.isEmpty()) {
            insert newOppConRole;
        }
    }

    public static void generateTaskForOpportunityOwner(List<Opportunity> opportunityList, Map<Id, Opportunity> mapToOldOpportunity){
    List<Task> taskList = new List<Task>();

    for (Opportunity opp : opportunityList) {

         if (((mapToOldOpportunity == null || !mapToOldOpportunity.containsKey(opp.Id)) && opp.StageName == 'Proposal/Price Quote') 
            ||(mapToOldOpportunity != null && mapToOldOpportunity.containsKey(opp.Id) && opp.StageName == 'Proposal/Price Quote' )) {
            System.debug('Creating Task for Opp ID: ' + opp.Id);
            taskList.add(new Task(
                Subject = 'Follow up call',
                OwnerId = opp.OwnerId,
                WhatId = opp.Id,
                ActivityDate = Date.today().addDays(3),
                Status = 'Not Started',
                Priority = 'Normal'
            ));
        } 
    }
        insert taskList;
}

}
