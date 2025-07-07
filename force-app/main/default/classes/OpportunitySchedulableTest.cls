@isTest
private class OpportunitySchedulableTest {

    @isTest
    static void testOpportunitySchedulable() {
    
        String cronExp = '0 0 0 * * ?';

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
            String jobId = System.schedule('Process Opportunities', cronExp, new OpportunitySchedulable());
        Test.StopTest();

        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE Id = :jobId];
        assert.areEqual(cronExp, ct.CronExpression, 'An Account should have been updated to Client');
    }
}