@isTest
private class OpportunityTriggerHandlerTest {

    @isTest
    static void validateDeleteTest() {
        Opportunity testOpp1 = new Opportunity(
            Name = 'Test Opp 1',
            StageName = 'Closed Won',
            CloseDate = System.today() + 3
        );

        Opportunity testOpp2 = new Opportunity(
            Name = 'Test Opp 2',
            StageName = 'Qualification',
            CloseDate = System.today() + 3
        );
        
        insert new List<Opportunity>{testOpp1, testOpp2};

        Test.startTest();
            try {
                delete testOpp1;
            } catch (Exception e) {
                Assert.isTrue(e.getMessage().contains('You cannot delete Opportunity with Closed Won stage'), 'Opportunity with Closed Won stage should not be deleted.');
            }

            delete testOpp2;
        Test.stopTest();

        List<Opportunity> deletedOpps = [SELECT Id FROM Opportunity WHERE Id = :testOpp2.Id];
        Assert.areEqual(0, deletedOpps.size(), 'Opportunity should be deleted.');
    }
}