@isTest
public class OPP_BTCH_Test {

    @testSetup
    static void setupTestData() {
        // Create 3 Accounts
        Account accGreen = new Account(Name = 'Account Green');
        Account accYellow = new Account(Name = 'Account Yellow');
        Account accRed = new Account(Name = 'Account Red');
        insert new List<Account>{ accGreen, accYellow, accRed };

        // Opportunities for Green (1 Closed Won)
        Opportunity opp1 = new Opportunity(
            Name = 'Opp Closed Won',
            StageName = 'Closed Won',
            CloseDate = Date.today(),
            Amount = 1000,
            AccountId = accGreen.Id
        );

        // Opportunities for Yellow (1 Open)
        Opportunity opp2 = new Opportunity(
            Name = 'Opp Open',
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(10),
            Amount = 2000,
            AccountId = accYellow.Id
        );

        // Opportunities for Red (1 Closed Lost)
        Opportunity opp3 = new Opportunity(
            Name = 'Opp Lost',
            StageName = 'Closed Lost',
            CloseDate = Date.today().addDays(-5),
            Amount = 500,
            AccountId = accRed.Id
        );

        insert new List<Opportunity>{ opp1, opp2, opp3 };
    }

    @isTest
    static void testBatchUpdatesImageStatus() {
        // Run the batch
        Test.startTest();
        OPP_BTCH oppbtch = new OPP_BTCH();
        Id batchId = Database.executeBatch(oppbtch);
        Test.stopTest();

         // Query all accounts and store in a map keyed by Name
        Map<String, Account> accMapByName = new Map<String, Account>();
        for (Account acc : [SELECT Name, Opportunity_Status__c FROM Account]) {
            accMapByName.put(acc.Name, acc);
        }

        // Now assert using name-based access
        System.assertEquals('Green', accMapByName.get('Account Green').Opportunity_Status__c);
        System.assertEquals('Yellow', accMapByName.get('Account Yellow').Opportunity_Status__c);
        System.assertEquals('Red', accMapByName.get('Account Red').Opportunity_Status__c);
    }

}
