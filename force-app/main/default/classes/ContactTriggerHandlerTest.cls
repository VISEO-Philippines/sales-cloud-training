@isTest
private class ContactTriggerHandlerTest {

    @isTest
    static void publishLogContactCreationTest() {
        Account testAccount = new Account(
            Name = 'Test Account'
        ); 
        insert testAccount;

        List<Contact> testContacts = new List<Contact>();
        testContacts.add(new Contact(
            FirstName = 'Test',
            LastName = 'Contact 1',
            AccountId = testAccount.Id,
            Email = 'sample1@mail.com'
        ));
        testContacts.add(new Contact(
            FirstName = 'Test',
            LastName = 'Contact 2',
            AccountId = testAccount.Id,
            Email = 'sample2@mail.com'
        ));
        insert testContacts;

        Test.startTest();
            delete testContacts;
        Test.stopTest();

        List<Contact_Delete_Log__c> testLogs = [ 
            SELECT AccountId__c, AccountName__c, Email__c, FirstName__c, LastName__c, Id__c, Deleted_Date_Time__c, Deleted_By_UserId__c
            FROM Contact_Delete_Log__c
        ];
        
        Assert.areEqual(2, testLogs.size(), 'Two contact logs should have been created');
        Assert.areEqual(testContacts[0].FirstName, testLogs[0].FirstName__c, 'Expecting Contact Logs to be the same');
        Assert.areEqual(testContacts[1].FirstName, testLogs[1].FirstName__c, 'Expecting Contact Logs to be the same');   
    }
}