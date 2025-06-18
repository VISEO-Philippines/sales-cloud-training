@isTest
private class OppSchedulable_UpdateIsClientFieldTest {

    @testSetup
    static void testData(){
        Account testAccount = new Account(); 
        testAccount.Name = 'Test Account';
        testAccount.Is_Client__c = false;
        
        insert testAccount;

        Opportunity testOpp = new Opportunity();
        testOpp.Name = 'Test Opp'; 
        testOpp.StageName = 'Closed Won';
        testOpp.AccountId = testAccount.Id;
        testOpp.CloseDate = System.today().addDays(30);
        
        insert testOpp;

        Opportunity testOpp2 = new Opportunity();
        testOpp2.Name = 'Test Opp'; 
        testOpp2.StageName = 'Closed Won';
        testOpp2.AccountId = testAccount.Id;
        testOpp2.CloseDate = System.today().addDays(30);
        
        insert testOpp2;
    }

    @isTest
    static void testSchedulable() {
        String cron = '0 0 0 * * ?'; // Daily at Midnight

        Test.startTest();
            String jobId = System.schedule('Test Opportunity_OpportunitySplit_Batchable', cron, new OppSchedulable_UpdateIsClientField());
        Test.stopTest();

        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE Id = :jobId];
        Assert.areEqual(cron, ct.CronExpression, 'Cron Expression should match passed parameter.');
    }
}