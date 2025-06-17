@isTest
private class OpportunityBatchHandlerTest {

    @isTest
    static void testOpportunityBatchHandler() {

        List<Account> testAccounts = new List<Account>{
            new Account(Name = 'Test 1', SLA__C = 'Gold', SLAExpirationDate__c = Date.newInstance(2025, 5, 31), SLASerialNumber__c = '123'),
            new Account(Name = 'Test 2', SLA__C = 'Gold', SLAExpirationDate__c = Date.newInstance(2025, 5, 31), SLASerialNumber__c = '123'),
            new Account(Name = 'Test 3', SLA__C = 'Gold', SLAExpirationDate__c = Date.newInstance(2025, 5, 31), SLASerialNumber__c = '123')
        };
        insert testAccounts;

        Opportunity testOpp = new Opportunity(
            Name = 'Test Opp 1',
            StageName = 'Closed Won',
            CloseDate = Date.today() +37,
            AccountId = testAccounts[0].Id
        );
        insert testOpp;

        Test.StartTest();
            OpportunityBatchHandler testOppBatch = new OpportunityBatchHandler();
            Database.executeBatch(testOppBatch);
        Test.StopTest();

        List<Account> result = [SELECT Id, Is_Client__c FROM Account WHERE Is_Client__c = TRUE LIMIT 1];
        assert.areEqual(1, result.size(), 'An Account should have been updated to Client');
    }

    
}