public with sharing class OpportunityTriggerHandler {
    public static void taskCreateOnStageProposal(List<Opportunity> oppListToUpdate, 
    Map<Id, Opportunity> oldOppMap) {
        
        List<Task> tasksToInsert = new List<Task>();
        
        for(Opportunity opp : oppListToUpdate) {
            boolean createTask = false;

            // for update
            if(oldOppMap != null && oldOppMap.containsKey(opp.Id)) {
                Opportunity oldOpp = oldOppMap.get(opp.Id);
                if(opp.StageName == 'Proposal/Price Quote' && oldOpp.StageName != 'Proposal/Price Quote') {
                    createTask = true;
                }
            } else {
                // for insert
                if(opp.StageName == 'Proposal/Price Quote') {
                    createTask = true;
                }
            }

            if(createTask) {
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