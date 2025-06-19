@isTest
private class CaseTriggerHandlerTest {

    @isTest
    static void caseAssignHighPriorityTest() {
        // retrieve the actual Group Id for the 'VIP Support Queue'
        Id vipQueueId = [SELECT Id FROM Group WHERE Name = 'VIP Support Queue' AND Type = 'Queue' LIMIT 1].Id;
        
        QueueSObject testQueue = new QueueSObject(QueueID = vipQueueId, SObjectType = 'Case');
        insert testQueue;

        System.runAs(new User(Id = UserInfo.getUserId())) {
            Test.startTest();
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
                Case testCase3 = new Case(
                    Subject  = 'Test Case 3',
                    Origin   = 'Phone',
                    Priority = 'Medium'
                );
                
                insert new List<Case>{testCase1, testCase2, testCase3};
                
                testCase3.Priority = 'High';
                update testCase3;

            Test.stopTest();
            
            List<Case> cases = [SELECT Id, OwnerId, Priority FROM Case];
            for(Case cs : cases) {
                if(cs.Priority == 'High') {
                    Assert.areEqual(vipQueueId, cs.OwnerId, 'High-priority case was not assigned to the VIP queue.');
                } else {
                    Assert.areNotEqual(vipQueueId, cs.OwnerId, 'Non-high-priority case was incorrectly assigned to the VIP queue.');
                }
            }
        }
    }
}