@isTest
private class CaseTriggerHandlerTest {

    @isTest
    static void caseAssignHighPriorityTest() {
        // Creating a VIP Support Queue group for high-priority case assignment
        Group testGroup = new Group (
            Name = 'VIP Support Queue',
            Type = 'Queue'
        );
        insert testGroup;

        QueueSObject testQueue = new QueueSObject(QueueID = testGroup.id, SObjectType = 'Case');
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

                insert testCase1;
                insert testCase2;
            Test.stopTest();

            Case caseResult1 = [SELECT OwnerId, Priority FROM Case WHERE Id = :testCase1.Id];
            Assert.areEqual(testGroup.Id, caseResult1.OwnerId, 'High-priority case was not assigned to the VIP queue as expected.');

            Case caseResult2 = [SELECT OwnerId, Priority FROM Case WHERE Id = :testCase2.Id];
            Assert.areNotEqual(testGroup.Id, caseResult2.OwnerId, 'Medium case was not assigned to the VIP queue as expected.');
        }
    }
}