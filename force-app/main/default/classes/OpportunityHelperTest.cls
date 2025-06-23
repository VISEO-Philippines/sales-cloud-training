@isTest
private class OpportunityHelperTest {

    @isTest
    static void testsendAlertForWonOpps() {

        Account testAccount = new Account(
            Name = 'Casting Czech',
            AccountNumber = '123456',
            Phone = '+43123423345',
            BillingCountry = 'Poland',
            BillingCity = 'Poznan',
            BillingStreet = 'Wolska',
            BillingPostalCode = '1234',
            Industry = 'Energy'
        );
        insert testAccount;

        List<Opportunity> testOppList = new List<Opportunity>{
                new Opportunity(Name = 'Casting Czech1',AccountId = testAccount.Id, StageName = 'Prospecting', CloseDate = Date.today(), Amount = 500000),
                new Opportunity(Name = 'Casting Czech2',AccountId = testAccount.Id, StageName = 'Prospecting', CloseDate = Date.today(), Amount = 600000),
                new Opportunity(Name = 'Casting Czech3',AccountId = testAccount.Id, StageName = 'Prospecting', CloseDate = Date.today(), Amount = 700000),
                new Opportunity(Name = 'Casting Czech4',AccountId = testAccount.Id, StageName = 'Prospecting', CloseDate = Date.today(), Amount = 800000),
                new Opportunity(Name = 'Casting Czech5',AccountId = testAccount.Id, StageName = 'Prospecting', CloseDate = Date.today(), Amount = 900000)
        };
        insert testOppList;

        for(Opportunity opp : testOppList){
            opp.StageName = 'Closed Won';
        }
        update testOppList; 
        
        Test.startTest();
            OpportunityHelper.sendAlertForWonOpps(testOppList);
        Test.stopTest();

        assert.areEqual(5, Limits.getEmailInvocations(), '5 Emails has been sent for each Closed Won Opps');
    }
}
