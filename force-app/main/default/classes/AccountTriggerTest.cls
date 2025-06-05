@isTest
private class AccountTriggerTest {
    @isTest
    static void testAccountWithImmediateContact() {
        Account acc = new Account(Name='Test Acc');
        insert acc;

        Contact con = new Contact(FirstName='John', LastName='Doe', AccountId=acc.Id);
        insert con;

        Test.startTest();
        // Triggers already fired during insert
        Test.stopTest();

        List<Task> tasks = [SELECT WhatId, WhoId FROM Task WHERE WhatId = :acc.Id];
        System.assertEquals(1, tasks.size());
        System.assertEquals(acc.Id, tasks[0].WhatId);
        System.assertEquals(con.Id, tasks[0].WhoId);
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
