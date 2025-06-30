public with sharing class OpportunityTriggerHandler {
    public static void taskCreateOnStageProposal(List<Opportunity> oppListToUpdate, Map<Id, Opportunity> oldOppMap) {
        
        List<Task> tasksToInsert = new List<Task>();
        
        for(Opportunity opp : oppListToUpdate) {
            if((oldOppMap == null && opp.StageName == 'Proposal/Price Quote') || 
               (oldOppMap != null && oldOppMap.get(opp.Id) != null && opp.StageName == 'Proposal/Price Quote' && oldOppMap.get(opp.Id).StageName != 'Proposal/Price Quote')) {
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
}