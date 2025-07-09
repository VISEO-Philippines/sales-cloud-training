public with sharing class OpportunityTriggerHandler {
    // US-6
    public static void taskCreateOnStageProposal(List<Opportunity> oppListToUpdate, Map<Id, Opportunity> oldOppMap) {
        
        List<Task> tasksToInsert = new List<Task>();
        
        for(Opportunity opp : oppListToUpdate) {
            if(opp.StageName == 'Proposal/Price Quote' && (oldOppMap == null || oldOppMap.get(opp.Id).StageName != 'Proposal/Price Quote')) {
                tasksToInsert.add(
                    new Task(
                        Subject = 'Follow up on Opportunity: ' + opp.Name,
                        OwnerId = opp.OwnerId,
                        WhoId = opp.ContactId,
                        WhatId = opp.Id,
                        ActivityDate = Date.today() + 3,
                        Status = 'Open'
                    )
                );
            }
        }
        insert tasksToInsert;
    }

    // US-2
    public static void addPrimaryContactRole(List<Opportunity> newOpportunityList) {
        List<OpportunityContactRole> contactRolesToInsertList = new List<OpportunityContactRole>();
        List<Opportunity> oppWithAccounts = new List<Opportunity>();
        
        // store the account Id to set [unique]
        Set<Id> accIds = new Set<Id>();
        for(Opportunity opp : newOpportunityList) {
            if(opp.AccountId != null) {
                accIds.add(opp.AccountId);
                oppWithAccounts.add(opp);
            }
        }

        // will store only one contact per account
        // loop through opportunity and contacts to match and create a contact role
        Map<Id, Id> accountIdContactIdMap = new Map<Id, Id>();    
        for(Contact conVar : [SELECT Id, AccountId FROM Contact WHERE AccountId IN: accIds]) {
            // first contact found will be stored in the map
            if(!accountIdContactIdMap.containsKey(conVar.AccountId)) {
                accountIdContactIdMap.put(conVar.AccountId, conVar.Id);
            }
        }
         
        for(Opportunity oppVar : oppWithAccounts) {
            Id primaryAccId = accountIdContactIdMap.get(oppVar.AccountId);
            // if the opportunity has an account and the account is in the map, create a contact role
            // and add it to the list of contact roles to insert
            // this will ensure that only one contact role is created per account
            // and the first contact found for that account will be used
            if(accountIdContactIdMap.containsKey(oppVar.AccountId)) {
                OpportunityContactRole conRole = new OpportunityContactRole(
                    OpportunityId = oppVar.Id,
                    ContactId = primaryAccId, 
                    Role = 'Primary',
                    IsPrimary = true
                );
                contactRolesToInsertList.add(conRole);
            }
        }
        // insert if there are contact roles inside the list
        insert contactRolesToInsertList;
    }
}