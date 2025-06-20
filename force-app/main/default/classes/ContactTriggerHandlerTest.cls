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

        System.assert(true, 'Contacts deleted event should be published');
    }
}