@isTest
private class OpportunityTriggerHandlerTest {

    @isTest
    static void taskCreateOnStageProposalTest() {
        Account testAccount = new Account(
            Name = 'Test Account'
        );
        insert testAccount;
        
        Contact testContact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            AccountId = testAccount.Id
        );
        insert testContact;

        Opportunity testOpportunity = new Opportunity(
            Name = 'Test Opportunity',
            StageName = 'Qualification',
            CloseDate = System.today() + 3,
            OwnerId = UserInfo.getUserId(),
            AccountId = testAccount.Id,
            ContactId = testContact.Id   
        );
        insert testOpportunity;

        Map<Id, Opportunity> oldOppMap = new Map<Id, Opportunity>();
        oldOppMap.put(testOpportunity.Id, testOpportunity.clone(true, true, true, true));

        testOpportunity.StageName = 'Proposal/Price Quote';

        Test.startTest();
            OpportunityTriggerHandler.taskCreateOnStageProposal(new List<Opportunity>{testOpportunity}, oldOppMap);
        Test.stopTest();

        List<Task> createdTasks = [
            SELECT Id, Subject, ActivityDate, OwnerId, WhatId, WhoId, Status
            FROM Task
        ];

        Assert.areEqual(1, createdTasks.size(), 'There should be exactly one task created.');
        
        Task followUpTask = createdTasks[0];

        Assert.areEqual('Follow up on Opportunity: ' + testOpportunity.Name, followUpTask.Subject, 'Task subject should match.');
        Assert.areEqual(Date.today() + 3, followUpTask.ActivityDate, 'The task should be due in 3 days from today.');
        Assert.areEqual(testOpportunity.OwnerId, followUpTask.OwnerId, 'The task owner should match the opportunity owner.');
        Assert.areEqual(testContact.Id, followUpTask.WhoId, 'The task WhoId should be the contact ID.');
    }
}