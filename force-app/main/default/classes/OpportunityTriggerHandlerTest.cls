@isTest
private class OpportunityTriggerHandlerTest {

    @isTest
    static void testCreateOpportunityContactRole() {
        
        Account testAccount = new Account(
            Name = 'testUS4Feature',
            Type = 'Feature Product',
            Rating = 'Warm',
            AccountNumber = '1234',
            Website = 'https://www.kevguy.com',
            Phone = '9876543210'
        );
        insert testAccount;

        Contact testContact = new Contact(
            FirstName = 'Keira',
            LastName = 'Bantot',
            AccountId = testAccount.Id
        );
        insert testContact;

        List<Opportunity> testOpportunities = new List<Opportunity>{
            new Opportunity(Name = 'Keira Opp1', StageName = 'Prospecting', Type = 'New Customer', CloseDate = Date.today().addDays(10), AccountId = testAccount.Id),
            new Opportunity(Name = 'Keira Opp2', StageName = 'Prospecting', Type = 'New Customer', CloseDate = Date.today().addDays(15), AccountId = testAccount.Id),
            new Opportunity(Name = 'Keira Opp3', StageName = 'Prospecting', Type = 'New Customer', CloseDate = Date.today().addDays(20), AccountId = testAccount.Id),
            new Opportunity(Name = 'Keira Opp4', StageName = 'Prospecting', Type = 'New Customer', CloseDate = Date.today().addDays(25), AccountId = testAccount.Id),
            new Opportunity(Name = 'Keira Opp5', StageName = 'Prospecting', Type = 'New Customer', CloseDate = Date.today().addDays(30), AccountId = testAccount.Id)
        };
        insert testOpportunities;

        Test.startTest();
            OpportunityTriggerHandler.createOpportunityContactRole(testOpportunities);
            List<OpportunityContactRole> ocrResult = [SELECT Id FROM OpportunityContactRole WHERE OpportunityId IN:testOpportunities LIMIT 5];
            System.assertEquals(5, ocrResult.size(), '5 Opportunity Contact Roles should be created (1 per Opportunity');
        Test.stopTest();
    }
}