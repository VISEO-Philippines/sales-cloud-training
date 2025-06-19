@isTest
private class OpportunityTriggerHandlerTest {

    @isTest
    static void sendEmailNotificationTest() {
        Account testAccount = new Account(
            Name = 'Test Account'
        );
        insert testAccount;

        Opportunity testOpp1 = new Opportunity(
            Name = 'Test Opp 1',
            StageName = 'Closed Won',
            Amount = 300000,
            CloseDate = System.today() + 3,
            AccountId = testAccount.Id,
            OwnerId = UserInfo.getUserId()
        );

        Opportunity testOpp2 = new Opportunity(
            Name = 'Test Opp 2',
            StageName = 'Qualification',
            Amount = 600000,
            CloseDate = System.today() + 3,
            AccountId = testAccount.Id,
            OwnerId = UserInfo.getUserId()
        );

        Opportunity testOpp3 = new Opportunity(
            Name = 'Test Opp 3',
            StageName = 'Closed Won',
            Amount = 600000,
            CloseDate = System.today() + 3,
            AccountId = testAccount.Id,
            OwnerId = UserInfo.getUserId()
        );      

        Test.startTest();
            // Insert opportunities
            insert new List<Opportunity>{testOpp1, testOpp2, testOpp3};

            // update testOpp2; 
            testOpp2.StageName = 'Closed Won';
            update testOpp2;

            Assert.areEqual(2, Limits.getEmailInvocations(), 'sendEmail should be called twice');    
        Test.stopTest();
    }
}