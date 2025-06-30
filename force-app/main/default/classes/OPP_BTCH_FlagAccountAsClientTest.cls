@isTest
public class OPP_BTCH_FlagAccountAsClientTest {
    @IsTest
    static void testBatchPositive() {
        // Create test Account with a Closed Won Opportunity
        Account acc = new Account(Name = 'Client Account', Is_Client__c = false);
        insert acc;

        Opportunity opp = new Opportunity(
            Name = 'Closed Won Opp',
            StageName = 'Closed Won',
            CloseDate = Date.today(),
            AccountId = acc.Id
        );
        insert opp;

        // Run the batch    
        Test.startTest();
        Database.executeBatch(new OPP_BTCH_FlagAccountAsClient(), 1);
        Test.stopTest();

        // Assert that Is_Client__c is now true
        Account updatedAcc = [SELECT Is_Client__c FROM Account WHERE Id = :acc.Id];
        Assert.areEqual(true, updatedAcc.Is_Client__c, 'Account should be marked as client');
    }
    @IsTest
    static void testBatchNegative() {
        // Account without Closed Won Opp
        Account acc = new Account(Name = 'Non-client Account', Is_Client__c = false);
        insert acc;

        Opportunity opp = new Opportunity(
            Name = 'Not Closed Won Opp',
            StageName = 'Prospecting',
            CloseDate = Date.today(),
            AccountId = acc.Id
        );
        insert opp;

        // Run the batch
        Test.startTest();
        Database.executeBatch(new OPP_BTCH_FlagAccountAsClient(), 1);
        Test.stopTest();

        // Assert that Is_Client__c is still false
        Account updatedAcc = [SELECT Is_Client__c FROM Account WHERE Id = :acc.Id];
        Assert.areEqual(false, updatedAcc.Is_Client__c, 'Account should not be marked as client');
    }
    @IsTest
    static void testBatchEmpty() {
        // Account with no opportunities
        Account acc = new Account(Name = 'No Opps', Is_Client__c = false);
        insert acc;

        Test.startTest();
        Database.executeBatch(new OPP_BTCH_FlagAccountAsClient(), 1);
        Test.stopTest();

        Account updatedAcc = [SELECT Is_Client__c FROM Account WHERE Id = :acc.Id];
        Assert.areEqual(false, updatedAcc.Is_Client__c, 'Account with no opps should not be marked as client');
    }
    @isTest
    static void testSchedulerExecutesBatch() {
        Test.startTest();
        
        // Run once daily at 12 AM
        String cron = '0 0 0 * * ? *'; 
        
        System.schedule('Test OPP Batch Scheduler', cron, new OPP_BTCH_FlagAccountAsClientScheduler());
        
        Test.stopTest();

        //Confirm it was scheduled
        CronTrigger ct = [SELECT Id, CronJobDetail.Name FROM CronTrigger WHERE CronJobDetail.Name = 'Test OPP Batch Scheduler' LIMIT 1];
        System.assertEquals('Test OPP Batch Scheduler', ct.CronJobDetail.Name);
    }

}
