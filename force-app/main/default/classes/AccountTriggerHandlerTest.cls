@isTest
private class AccountTriggerHandlerTest {

    @isTest
    static void testCreateDefaultContactAndTaskForAccounts() {
        Account acc = new Account(Name = 'Test Account', OwnerId = UserInfo.getUserId());
        insert acc;

        Test.startTest();
        AccountTriggerHandler.createDefaultContactAndTaskForAccounts(new List<Account>{acc});
        Test.stopTest();

        // Assert Contact
        Contact con = [SELECT Id, AccountId FROM Contact WHERE AccountId = :acc.Id ];
        Assert.areEqual(acc.Id, con.AccountId, 'The Contact should be related to the Account');

        // Assert Task
        Task task = [SELECT WhatId, WhoId FROM Task WHERE WhatId = :acc.Id ];
        Assert.areEqual(acc.Id, task.WhatId, 'The Task should be related to the Account');
        Assert.areEqual(con.Id, task.WhoId, 'The Task should be related to the Contact');
    }
}