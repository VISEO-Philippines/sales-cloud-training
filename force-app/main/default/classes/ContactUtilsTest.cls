@isTest
private class ContactUtilsTest {

    @isTest
    static void testGetOppsFromContact() {
     
        Account testAccount  = new Account (
            Name = 'Fujio Residences Bldg 1',
            BillingCity = 'Tokyo',
            BillingCountry = 'Japan',
            BillingState = 'Tokyo',
            BillingStreet = 'Fujiya',
            BillingPostalCode = '12345',
            Phone = '090-0000-0000',
            AccountNumber = '5400',
            Website = 'https://fujio.co.jp/'
        );
        insert testAccount;

        List<Opportunity> testOppsList = new List<Opportunity>{
                new Opportunity(Name = 'Test Opp1 for Fujio Bldg 1', StageName = 'New', CloseDate = Date.today() +37, AccountId = testAccount.Id),
                new Opportunity(Name = 'Test Opp2 for Fujio Bldg 1', StageName = 'Negotiation', CloseDate = Date.today() +37, AccountId = testAccount.Id),
                new Opportunity(Name = 'Test Opp3 for Fujio Bldg 1', StageName = 'Quote sent', CloseDate = Date.today() +37, AccountId = testAccount.Id)
        };
        insert testOppsList;

        Contact testContact = new Contact (
            FirstName = 'Kevin', 
            LastName = 'Guyo', 
            AccountId = testAccount.Id
        );
        insert testContact;

        Test.StartTest();
            Integer oppCount = ContactUtils.getOppsFromContact();
        Test.StopTest();

        assert.areEqual(testOppsList.size(), oppCount);
    }
}