@isTest
private class OpportunityHandlerTest {

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
            StageName = 'Closed Won',
            Amount = 600000,
            CloseDate = System.today() + 3,
            AccountId = testAccount.Id,
            OwnerId = UserInfo.getUserId()
        );

        insert new List<Opportunity>{testOpp1, testOpp2};

        Test.startTest();
            OpportunityHandler.sendEmailNotification(new List<Id>{testOpp1.Id, testOpp2.Id});     
            Assert.areEqual(1, Limits.getEmailInvocations(), 'sendEmail should be called once');  
        Test.stopTest();
    }
}