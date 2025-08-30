@isTest
private class CaseTriggerHandlerTest {

    @testSetup
    static void setupData() {
        Group vipQueue = new Group(
            Name = 'VIP Support Queue',
            Type = 'Queue'
        );
        insert vipQueue;
    }

    @isTest
    static void caseAssignHighPriority_InsertTest() {
        // retrieve the actual Group for the 'VIP Support Queue'
        Group vipQueue = [SELECT Id FROM Group WHERE Name = 'VIP Support Queue' AND Type = 'Queue' LIMIT 1];

        Case testCase1 = new Case(
            Subject  = 'Test Case 1',
            Origin   = 'Phone',
            Priority = 'High'
        );
        Case testCase2 = new Case(
            Subject  = 'Test Case 2',
            Origin   = 'Phone',
            Priority = 'Medium'
        );
        
        Test.startTest();
            CaseTriggerHandler.caseAssignHighPriority(new List<Case>{testCase1, testCase2}, null);
        Test.stopTest();
        
        Assert.areEqual(vipQueue.Id, testCase1.OwnerId, 'High-priority case was not assigned to the VIP queue.');
    }

    @isTest
    static void caseAssignHighPriority_UpdateTest() {
       // retrieve the actual Group for the 'VIP Support Queue'
        Group vipQueue = [SELECT Id FROM Group WHERE Name = 'VIP Support Queue' AND Type = 'Queue' LIMIT 1];

        Case testCaseToUpdate = new Case(
            Subject  = 'Test Case 1',
            Origin   = 'Phone',
            Priority = 'Medium'
        );
        insert testCaseToUpdate;

        Map<Id, Case> oldCaseMap = new Map<Id, Case>();
        oldCaseMap.put(testCaseToUpdate.Id, testCaseToUpdate.clone(true, true, true, true));

        // Update the priority of testCaseToUpdate to High
        testCaseToUpdate.Priority = 'High';
        
        Test.startTest();
            CaseTriggerHandler.caseAssignHighPriority(new List<Case>{testCaseToUpdate}, oldCaseMap);
        Test.stopTest();
        
        Assert.areEqual(vipQueue.Id, testCaseToUpdate.OwnerId, 'High-priority case was not assigned to the VIP queue on update.');
    }
}