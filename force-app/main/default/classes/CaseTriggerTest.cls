@isTest
private class CaseTriggerTest {

    @isTest
    static void testCaseAssignmentOnUpdate() {
        // Insert a case with a non-high priority
        Case cs = new Case(
            Origin = 'Phone',
            Status = 'New',
            Priority = 'Medium'
        );
        insert cs;

        // Change priority to High to trigger reassignment to queue
        cs.Priority = 'High';

        Test.startTest();
        update cs;
        Test.stopTest();

        // Get the Group ID of the VIP Support queue
        Id queueId = [SELECT Id FROM Group WHERE Name = 'VIP Support' AND Type = 'Queue' LIMIT 1].Id;

        // Fetch the updated case
        Case updatedCase = [SELECT Id, OwnerId, Priority FROM Case WHERE Id = :cs.Id];

        // Assert that the case owner was updated to the queue
        System.assertEquals(queueId, updatedCase.OwnerId, 'Case should be assigned to the VIP Support queue');
    }

    @isTest
    static void testCaseAssignmentOnInsert() {
        // Create a case with High priority
        Case cs = new Case(
            Origin = 'Phone',
            Status = 'New',
            Priority = 'High'
        );

        Test.startTest();
        insert cs;
        Test.stopTest();

        // Get the Group ID of the VIP Support queue
        Id queueId = [SELECT Id FROM Group WHERE Name = 'VIP Support' AND Type = 'Queue' LIMIT 1].Id;

        // Fetch the inserted case
        Case insertedCase = [SELECT Id, OwnerId, Priority FROM Case WHERE Id = :cs.Id];

        // Assert that the case owner is the queue
        System.assertEquals(queueId, insertedCase.OwnerId, 'Case should be assigned to the VIP Support queue');
    }
}
