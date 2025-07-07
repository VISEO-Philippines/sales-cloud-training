
@isTest
private class ContactTriggerHelperTest {

    @isTest
    static void testDeletedContactToLogs() {
        //create new contact
        Account acc = new Account(
            Name = 'Samael Account'
        );
        Contact con = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Phone = '1234567890',
            Email = 'testAcc@123.com',
            Account = acc
        );

        Contact con1 = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Phone = '1234567890',
            Email = 'testAcc@123.com',
            Account = acc
        );
        List<Contact> conList = new List<Contact>{con, con1};
        insert acc;
        insert conList;

        test.startTest();
        delete conList;
        test.stopTest();

        List<Contact_Delete_Log__c> logs = [SELECT Id, Name, First_Name__c, Last_Name__c, Email__c, Phone__c, Account_Name__c
                                            FROM Contact_Delete_Log__c];
        Assert.areEqual(2, logs.size());
    }
}