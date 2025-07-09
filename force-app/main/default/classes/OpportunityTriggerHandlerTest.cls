@isTest
private class OpportunityTriggerHandlerTest {

    @TestSetup
    static void testData(){
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
    }

    // US-6
    @isTest
    static void taskCreateOnStageProposalTest() {
        Account testAccount = [SELECT Id FROM Account WHERE Name = 'Test Account' LIMIT 1];
        Contact testContact = [SELECT Id FROM Contact WHERE FirstName = 'Test' AND LastName = 'Contact' LIMIT 1];
        Opportunity testOpportunity = [SELECT Id, Name, StageName, OwnerId, AccountId, ContactId FROM Opportunity WHERE Name = 'Test Opportunity' LIMIT 1];

        Map<Id, Opportunity> oldOppMap = new Map<Id, Opportunity>();
        oldOppMap.put(testOpportunity.Id, testOpportunity.clone(true, true, true, true));

        testOpportunity.StageName = 'Proposal/Price Quote';
        update testOpportunity;

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

    // US-2
    @isTest
    static void testAddPrimaryContactRole() {
        Account testAccount = [SELECT Id FROM Account WHERE Name = 'Test Account' LIMIT 1];
        Contact testContact = [SELECT Id FROM Contact WHERE FirstName = 'Test' AND LastName = 'Contact' LIMIT 1];

        Opportunity testOppConRole = new Opportunity(
            Name = 'Test Opp', 
            CloseDate = System.today().addDays(30), 
            StageName = 'Prospecting',
            AccountId = testAccount.Id            
        );
        insert testOppConRole;

        Test.startTest();
            OpportunityTriggerHandler.addPrimaryContactRole(new List<Opportunity>{testOppConRole});
        Test.stopTest();

        List<OpportunityContactRole> insertedOppConRole = [
            SELECT ContactId, IsPrimary, OpportunityId, Role
            FROM OpportunityContactRole 
            WHERE OpportunityId = :testOppConRole.Id
        ];

        Assert.areEqual(1, insertedOppConRole.size(), 'There should be one OpportunityContactRole record.');
        Assert.areEqual(testOppConRole.Id, insertedOppConRole[0].OpportunityId, 'The Opportunity ID should match the ID of the Opportunity created.');
        Assert.isTrue(insertedOppConRole[0].IsPrimary, 'The contact role should be marked as primary.');
        Assert.areEqual('Primary', insertedOppConRole[0].Role, 'The Role should be Primary.');
    }
    
}