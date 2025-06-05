@isTest
private class OpportunityTriggerHandlerTest {

    @isTest
    static void taskCreateOnStageProposalTest() {
        
        Opportunity testOpportunity = new Opportunity(
            Name = 'Test Opportunity',
            StageName = 'Proposal/Price Quote',
            CloseDate = System.today() + 3,
            OwnerId = UserInfo.getUserId()
        );

        Test.startTest();
            insert testOpportunity;
        Test.stopTest();

        List<Task> tasks = [SELECT Id, ActivityDate, OwnerId FROM Task WHERE WhatId = :testOpportunity.Id];
        
        Assert.areEqual(1, tasks.size(), 'There should be one task');
        Assert.areEqual(Date.today() + 3, tasks[0].ActivityDate, 'The task should be due in 3 days');
        Assert.areEqual(testOpportunity.OwnerId, tasks[0].OwnerId, 'The task owner should match the opportunity owner');
    }
}