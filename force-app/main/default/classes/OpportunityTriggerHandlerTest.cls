@isTest
private class OpportunityTriggerHandlerTest {

    @TestSetup
    static void testData(){
         Account testAccount = new Account(
            Name = 'Test Account'
        );
        insert testAccount;

        User testUser = new User(
            Alias = 'testuser',
            Email = 'testuser00@mail.com',
            EmailEncodingKey = 'UTF-8',
            Username = 'testuser00@mail.com',
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1].Id,
            FirstName = 'Test',
            LastName = 'User',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'America/Los_Angeles'
        );
        insert testUser;
    }

    @isTest
    static void sendEmailNotification_InsertTest() {
        // Retrieve the test account and user created in the @TestSetup method
        Account testAccount = [SELECT Id FROM Account WHERE Name = 'Test Account' LIMIT 1];
        User testUser = [SELECT Id, Email, FirstName, LastName FROM User WHERE Alias = 'testuser' LIMIT 1];

        System.debug('Insert Test: Retrieved Account Id: ' + testAccount.Id);
        System.debug('Insert Test: Retrieved User Id: ' + testUser.Id + ', Email: ' + testUser.Email);

        Opportunity testOpp1 = new Opportunity(
            Name = 'Test Opp 1',
            StageName = 'Closed Won',
            Amount = 800000,
            CloseDate = System.today() + 3,
            AccountId = testAccount.Id,
            OwnerId = testUser.Id
        );

        Opportunity testOpp2 = new Opportunity(
            Name = 'Test Opp 2',
            StageName = 'Qualification',
            Amount = 600000,
            CloseDate = System.today() + 3,
            AccountId = testAccount.Id,
            OwnerId = testUser.Id
        );
        insert new List<Opportunity>{testOpp1, testOpp2};

        Test.startTest();
            OpportunityTriggerHandler.sendEmailNotification(new List<Opportunity>{testOpp1, testOpp2}, null);
            Assert.areEqual(1, Limits.getEmailInvocations(), 'sendEmail should be called once');   
        Test.stopTest();
    }

    @isTest
    static void sendEmailNotification_UpdateTest() {
        // Retrieve the test account and user created in the @TestSetup method
        Account testAccount = [SELECT Id FROM Account WHERE Name = 'Test Account' LIMIT 1];
        User testUser = [SELECT Id, Email, FirstName, LastName FROM User WHERE Alias = 'testuser' LIMIT 1];

        Opportunity testOppToUpdate = new Opportunity(
            Name = 'Test Opp 1',
            StageName = 'Qualification',
            Amount = 800000,
            CloseDate = System.today() + 3,
            AccountId = testAccount.Id,
            OwnerId = testUser.Id
        );

        Opportunity testOppWon = new Opportunity(
            Name = 'Test Opp 2',
            StageName = 'Qualification',
            Amount = 600000,
            CloseDate = System.today() + 3,
            AccountId = testAccount.Id,
            OwnerId = testUser.Id
        );      

        // Insert opportunities
        insert new List<Opportunity>{testOppToUpdate, testOppWon};

        Map<Id, Opportunity> oldOppMap = new Map<Id, Opportunity>();
        oldOppMap.put(testOppToUpdate.Id, testOppToUpdate.clone(true, true, true, true));
        oldOppMap.put(testOppWon.Id, testOppWon.clone(true, true, true, true));
        
        // Update opp stage
        testOppToUpdate.StageName = 'Closed Won';

        List<Opportunity> newOpps = new List<Opportunity>{testOppToUpdate, testOppWon};

        Test.startTest();
            OpportunityTriggerHandler.sendEmailNotification(newOpps, oldOppMap);
            Assert.areEqual(1, Limits.getEmailInvocations(), 'sendEmail should be called once');  
        Test.stopTest();
    }
}