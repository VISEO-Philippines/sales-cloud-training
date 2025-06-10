@isTest
private class AccountTriggerHandlerTest {

    @isTest
    static void testCreateContactAndTask() {
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        Map<Id, Account> accMap = new Map<Id, Account>{ acc.Id => acc };

        Test.startTest();
        AccountTriggerHandler.createContactAndTask(accMap);
        Test.stopTest();

        // Assert Contact
        Contact con = [SELECT Id, AccountId FROM Contact WHERE AccountId = :acc.Id LIMIT 1];
        System.assertEquals(acc.Id, con.AccountId);

        // Assert Task
        Task task = [SELECT WhatId, WhoId FROM Task WHERE WhatId = :acc.Id LIMIT 1];
        System.assertEquals(acc.Id, task.WhatId);
        System.assertEquals(con.Id, task.WhoId);
    }


    @isTest
    static void testAccountWithoutContactThenAddContact() {
        Account acc = new Account(Name='Test Acc');
        insert acc;

        Test.startTest();
        List<Task> tasks = [SELECT WhatId, WhoId FROM Task WHERE WhatId = :acc.Id];
        Test.stopTest();

        System.assertEquals(1, tasks.size());
        System.assertEquals(null, tasks[0].WhoId);

        Contact con = new Contact(FirstName='Jane', LastName='Smith', AccountId=acc.Id);
        insert con;

        List<Task> updatedTasks = [SELECT WhatId, WhoId FROM Task WHERE WhatId = :acc.Id];
        System.assertEquals(1, updatedTasks.size());
        System.assertEquals(con.Id, updatedTasks[0].WhoId);
    }
}
