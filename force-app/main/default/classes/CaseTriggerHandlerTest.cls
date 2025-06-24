@isTest
private class CaseTriggerHandlerTest {

    @isTest
    static void testCaseTriggerHandler() {

    Map<Id, Case> oldCaseMap  = new Map<Id, Case>();
    List<Case> newCaseList = new List<Case>();    
        
    Case testCase = new Case(
        Origin = 'Phone',
        Status = 'New',
        Subject = 'Test Case',
        Priority = 'Medium'
    );
    insert testCase;
    oldCaseMap.put(testCase.Id, testCase);


    testCase.Priority = 'High';
    update testCase;
    newCaseList.add(testCase);

    Test.startTest();
        CaseTriggerHandler.assignPriorityCasesToQueue(newCaseList, oldCaseMap);
    Test.stopTest();

    Id vipSupportQueueId = [SELECT Id FROM Group WHERE Name = 'VIP Support Queue' AND Type = 'Queue' LIMIT 1].Id;

    Case updateCase = [SELECT Id, OwnerId FROM CASE WHERE Id =: testCase.Id LIMIT 1];
    assert.areEqual(vipSupportQueueId, updateCase.OwnerId, 'Case owner should be updated to VIP Queue');

    }
}