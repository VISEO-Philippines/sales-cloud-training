@isTest
private class CaseTriggerTest {

    @isTest
    static void testCaseAssignmentOnUpdate() {
        Case cs = new Case(
            Origin = 'Phone',
            Status = 'New',
            Priority = 'Medium'
        );
        insert cs;

        cs.Priority = 'High';

        Test.startTest();
        update cs;
        Test.stopTest();

        Id queueId = [SELECT Id FROM Group WHERE Name = 'VIP Support' AND Type = 'Queue' LIMIT 1].Id;

        Case updatedCase = [SELECT Id, OwnerId, Priority FROM Case WHERE Id = :cs.Id];

        System.assertEquals(queueId, updatedCase.OwnerId, 'Case should be assigned to the VIP Support queue');
    }

    @isTest
    static void testCaseAssignmentOnInsert() {
        Case cs = new Case(
            Origin = 'Phone',
            Status = 'New',
            Priority = 'High'
        );

        Test.startTest();
        insert cs;
        Test.stopTest();

        Id queueId = [SELECT Id FROM Group WHERE Name = 'VIP Support' AND Type = 'Queue' LIMIT 1].Id;

        Case insertedCase = [SELECT Id, OwnerId, Priority FROM Case WHERE Id = :cs.Id];

        System.assertEquals(queueId, insertedCase.OwnerId, 'Case should be assigned to the VIP Support queue');
    }
}
