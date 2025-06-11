public with sharing class OpportunityTriggerHandler {

    public static void createOpportunityContactRole(List<Opportunity> opportunityList) {

        Set<Id> opportunityAccountIds = new Set<Id>();
        List<OpportunityContactRole> opportunityContactRolesList = new List<OpportunityContactRole>();
        
        for(Opportunity opp : opportunityList) {
        {
            if(opp.AccountId <> null){
                opportunityAccountIds.add(opp.AccountId);
            }
        }
        List<Contact> contactList = [SELECT Id, AccountId FROM Contact WHERE AccountId IN : opportunityAccountIds];

        for(Contact con :contactList) {
            opportunityContactRolesList.add(
                new OpportunityContactRole(
                    OpportunityId = opp.Id,
                    ContactId = con.Id,
                    Role = 'Business User',
                    IsPrimary = true) 
                );
            }
        }
        insert opportunityContactRolesList; 
    }

    public static void createTaskWhenOppStageProposalPriceQuote(List<Opportunity> opportunityList, Map<Id, Opportunity> oldOpportunityMap) {
        
        List<Task> createFollowUpTasksList = new List<Task>(); 

        for(Opportunity opp : opportunityList){
            if(opp.StageName == 'Proposal/Price Quote' && oldOpportunityMap.get(opp.Id).StageName != 'Proposal/Price Quote' && opp.IsWon != TRUE){
                        Task reminderTask = new Task(
                        OwnerId = opp.OwnerId,
                        WhatId = opp.Id,
                        Subject = 'Email',
                        TaskSubtype = 'Task',
                        Status = 'Not Started',
                        ActivityDate = Date.today(),
                        ReminderDateTime = Date.today() + 3,
                        IsReminderSet = true
                    );
                    createFollowUpTasksList.add(reminderTask);
            }
        }
        insert createFollowUpTasksList;
    }
}
