@isTest
private class ContactUtilsTest {

    @isTest
    static void getOppCountForContactAccountsTest() {
        Account testAcc1 = new Account(Name = 'Test Account 1');
        Account testAcc2 = new Account(Name = 'Test Account 2');
        insert new List<Account>{testAcc1, testAcc2};
        

        Contact testCon1 = new Contact(FirstName = 'Test', LastName = 'Contact 1' , AccountId = testAcc1.Id);
        Contact testCon2 = new Contact(FirstName = 'Test', LastName = 'Contact 2' , AccountId = testAcc2.Id);
        insert new List<Contact>{testCon1, testCon2};

        Opportunity testOpp1 = new Opportunity(Name = 'Test Opp 1', AccountId = testAcc1.Id, StageName = 'Closed Won', CloseDate = Date.today());
        Opportunity testOpp2 = new Opportunity(Name = 'Test Opp 2', AccountId = testAcc1.Id, StageName = 'Closed Won', CloseDate = Date.today());
        Opportunity testOpp3 = new Opportunity(Name = 'Test Opp 3', AccountId = testAcc2.Id, StageName = 'Closed Won', CloseDate = Date.today());
        insert new List<Opportunity>{testOpp1, testOpp2, testOpp3};

        Test.startTest();
            Integer oppConCount1 = ContactUtils.getOppCountForContactAccounts(new List<Id>{testCon1.Id});
            Integer oppConCount2 = ContactUtils.getOppCountForContactAccounts(new List<Id>{testCon2.Id});
        Test.stopTest();

        Assert.areEqual(2, oppConCount1, 'Opportunity Count for Test Contact 1 should be 2');
        Assert.areEqual(1, oppConCount2, 'Opportunity Count for Test Contact 2 should be 1');
    }

    @isTest
    static void contactWithNoAccountTest() {
        Contact testCon = new Contact(FirstName = 'Test', LastName = 'Contact');
        insert testCon;

        Test.startTest();
            Integer oppConCount = ContactUtils.getOppCountForContactAccounts(new List<Id>{testCon.Id});
        Test.stopTest();

        Assert.areEqual(0, oppConCount, 'Opp Count for Contact without Account should be 0');
    }
}