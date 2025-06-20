@isTest
private class ContactEventTriggerHandlerTest {

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

        List<Contact_Delete_Event__e> testContactEvents = new List<Contact_Delete_Event__e>();
        for(Contact conToLog : testContacts){
            testContactEvents.add(new Contact_Delete_Event__e(Contact_JSON__c = JSON.serialize(conToLog)));
        }
        

        Test.startTest();
            ContactEventTriggerHandler.publishLogContactCreation(testContactEvents);
        Test.stopTest();

        List<Contact_Delete_Log__c> testLogs = [ 
            SELECT AccountId__c, AccountName__c, Email__c, FirstName__c, LastName__c, Id__c, Deleted_Date_Time__c, Deleted_By_UserId__c
            FROM Contact_Delete_Log__c
        ];
        
        Assert.areEqual(2, testLogs.size(), 'Two contact logs should have been created');

        Map<Id, Contact> testContactsMap = new Map<Id, Contact>();
        for(Contact_Delete_Log__c con : testLogs){
            Contact tester = testContactsMap.get(con.Id__c);
            Assert.isNull(tester, 'Contact should not be found in the database');
            Assert.areNotEqual(null, con.AccountId__c, 'Account ID should not be null');
        }
         
    }
}