@isTest
private class AccountTriggerHandlerTest {

    @isTest
    static void assignTaskTest() {
        // create test data
        Account testAccount = new Account(
            Name = 'Test Account'
        );

        Test.startTest();
            insert testAccount;
        Test.stopTest();

        
        Contact createdContact = [SELECT Id, FirstName, LastName, AccountId FROM Contact WHERE AccountId = :testAccount.Id LIMIT 1];

        Assert.isNotNull(createdContact, 'A contact should be created for the test account');
        Assert.areEqual('Default', createdContact.FirstName, 'Contact first name should be "Default".');
        Assert.areEqual('Contact', createdContact.LastName, 'Contact last name should be "Contact".');
        Assert.areEqual(testAccount.Id, createdContact.AccountId, 'Contact should be linked to the test account.');
    }
}