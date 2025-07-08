@isTest
public class OPP_BTCH_FlagAccountAsClientTest {

    @TestSetup
    static void makeData(){
        // Create test Accounts
        Account account1 = new Account(Name = 'No Closed Won Opp', Is_Client__c = false);
        Account account2 = new Account(Name = 'With Closed Won Opp', Is_Client__c = false);
        Account account3 = new Account(Name = 'No Opp', Is_Client__c = false);

        List<Account> lstAccounts = new List<Account>{ account1, account2, account3 };
        insert lstAccounts;
       
        List<Opportunity> lstOpportunities = new List<Opportunity>();
        lstOpportunities.add(new Opportunity(
            Name = 'Not Closed Won Opp',
            StageName = 'Prospecting',
            CloseDate = Date.today(),
            AccountId = account1.Id
        ));
        lstOpportunities.add(new Opportunity(
            Name = 'Closed Won Opp',
            StageName = 'Closed Won',
            CloseDate = Date.today(),
            AccountId = account2.Id
        ));
        insert lstOpportunities;
    }

    @IsTest
    static void testBatchPositive() {
        Test.startTest();
        Database.executeBatch(new OPP_BTCH_FlagAccountAsClient(), 1);
        Test.stopTest();

        Account updatedAcc = [SELECT Is_Client__c FROM Account WHERE Name = 'With Closed Won Opp'];
        Assert.areEqual(true, updatedAcc.Is_Client__c, 'Account should be marked as client');
    }

    @IsTest
    static void testBatchNegative() {
        Test.startTest();
        Database.executeBatch(new OPP_BTCH_FlagAccountAsClient(), 1);
        Test.stopTest();

        Account updatedAcc = [SELECT Is_Client__c FROM Account WHERE Name = 'No Closed Won Opp'];
        Assert.areEqual(false, updatedAcc.Is_Client__c, 'Account should not be marked as client');
    }

    @IsTest
    static void testBatchEmpty() {
        Test.startTest();
        Database.executeBatch(new OPP_BTCH_FlagAccountAsClient(), 1);
        Test.stopTest();

        Account updatedAcc = [SELECT Is_Client__c FROM Account WHERE Name = 'No Opp'];
        Assert.areEqual(false, updatedAcc.Is_Client__c, 'Account with no opps should not be marked as client');
    }

    @isTest
    static void testSchedulerExecutesBatch() {
        Test.startTest();
        String cron = '0 0 0 * * ? *'; 
        System.schedule('Test OPP Batch Scheduler', cron, new OPP_BTCH_FlagAccountAsClientScheduler());
        Test.stopTest();

        CronTrigger ct = [SELECT Id, CronJobDetail.Name FROM CronTrigger WHERE CronJobDetail.Name = 'Test OPP Batch Scheduler' LIMIT 1];
        Assert.areEqual('Test OPP Batch Scheduler', ct.CronJobDetail.Name, 'Batch class should be scheduled');
    }
}
