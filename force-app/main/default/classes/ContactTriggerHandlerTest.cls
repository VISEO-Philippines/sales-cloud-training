@isTest
private class ContactTriggerHandlerTest {

    @isTest
    static void addAssignTaskTest() {
        Account testAccount = new Account(
            Name = 'Test Account'
        );
        insert testAccount;

        Contact testContact = new Contact(
            FirstName = 'Simple',
            LastName = 'Tester',
            AccountId = testAccount.Id,
            OwnerId = UserInfo.getUserId()
        );

        Test.startTest();
            insert testContact;
        Test.stopTest();

        List<Task> createdTasks = [
            SELECT Id, OwnerId, Status, Subject, WhoId, WhatId, Priority, ActivityDate
            FROM Task
            WHERE WhoId = :testContact.Id AND WhatId = :testAccount.Id
        ];

        Assert.areEqual(1, createdTasks.size(), 'Verify that a single task is created for the test account.');
        Assert.areEqual(testContact.Id, createdTasks[0].WhoId, 'Task should be related to the contact.');
        Assert.areEqual(testAccount.Id, createdTasks[0].WhatId, 'Task should be related to the account.');
    }
}