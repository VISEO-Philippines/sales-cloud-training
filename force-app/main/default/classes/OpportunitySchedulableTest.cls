@isTest
private class OpportunitySchedulableTest {

    @isTest
    static void myUnitTest() {

        Account testAccount = new Account(
            Name = 'Test',
            SLA__C = 'Gold',
            SLAExpirationDate__c = Date.newInstance(2025, 5, 31),
            SLASerialNumber__c = '123'
        );
        insert testAccount;

        List<Opportunity> newTestOpp = new List<Opportunity>{
            new Opportunity(Name = 'Test Opp 1', StageName = 'Closed Won', CloseDate = Date.today() +37, AccountId = testAccount.Id),
            new Opportunity(Name = 'Test Opp 2', StageName = 'Closed Won', CloseDate = Date.today() +37, AccountId = testAccount.Id),
            new Opportunity(Name = 'Test Opp 2', StageName = 'Closed Won', CloseDate = Date.today() +37, AccountId = testAccount.Id)
        };
        insert newTestOpp;

        Test.StartTest();
            OpportunitySchedulable testOppBatch = new OpportunitySchedulable();
            testOppBatch.execute(null);
        Test.StopTest();

        List<Account> result = [SELECT Id, Is_Client__c FROM Account WHERE Is_Client__c = TRUE];
        System.assertEquals(1, result.size(), 'An Account should have been updated to Client');
    }
}