@isTest
private class AccountTriggerHandlerTest {

    @isTest
    static void testCreateContactWithAccountName() {
    
    List<Account> testAccounts = new List<Account>();

        Account testAccount = new Account(
            Name = 'Fujio Residences',
            BillingCity = 'Tokyo',
            BillingCountry = 'Japan',
            BillingState = 'Tokyo',
            BillingStreet = 'Fujiya',
            BillingPostalCode = '12345',
            Phone = '090-0000-0000',
            AccountNumber = '5400',
            Website = 'https://fujio.co.jp/'
            
        );
        testAccounts.add(testAccount);
        insert testAccounts;
        
        Test.startTest();
        AccountTriggerHandler.createContactWithAccountName(testAccounts);
        Test.stopTest();

        LIST<Task> result = [SELECT Id FROM Task WHERE WhatId IN :testAccounts];
        System.assertEquals(1, result.size(), 'A Task has been created for the inserted Account');
    }
}