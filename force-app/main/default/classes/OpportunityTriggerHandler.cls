public with sharing class OpportunityTriggerHandler {
    public static void taskCreateOnStageProposal(List<Opportunity> oppListToUpdate) {

        List<Task> tasksToInsert = new List<Task>();
        for(Opportunity opp : oppListToUpdate) {
            if(opp.StageName == 'Proposal/Price Quote') {
                Task followUpTask = new Task();
                followUpTask.Subject = 'Follow up on Opportunity: ' + opp.Name; 
                followUpTask.OwnerId = opp.OwnerId;
                followUpTask.WhoId = opp.ContactId;
                followUpTask.WhatId = opp.Id;
                followUpTask.ActivityDate = Date.today() + 3;
                followUpTask.Status = 'Open';
                tasksToInsert.add(followUpTask);
            }
        }
        
        insert tasksToInsert;
    }
}