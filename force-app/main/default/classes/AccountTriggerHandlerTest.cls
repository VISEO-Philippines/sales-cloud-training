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

        Assert.isTrue([SELECT Id FROM Task WHERE WhatId = :testAccount.Id].size() == 1, 'There should be one task');
        Assert.areEqual([SELECT Id FROM Contact WHERE AccountId = :testAccount.Id].size(), 1, 'There should be one contact');
    }
}