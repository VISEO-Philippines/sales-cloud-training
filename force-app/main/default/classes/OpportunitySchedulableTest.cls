@isTest
private class OpportunitySchedulableTest {

    @testSetup
    static void testData(){
        Account testAccount = new Account(); 
        testAccount.Name = 'Test Account';
        testAccount.Is_Client__c = false;
        
        insert testAccount;

        Opportunity testOpp = new Opportunity();
        testOpp.Name = 'Test Opp'; 
        testOpp.StageName = 'Closed Won';
        testOpp.AccountId = testAccount.Id;
        testOpp.CloseDate = System.today().addDays(30);
        
        insert testOpp;

        Opportunity testOpp2 = new Opportunity();
        testOpp2.Name = 'Test Opp'; 
        testOpp2.StageName = 'Closed Won';
        testOpp2.AccountId = testAccount.Id;
        testOpp2.CloseDate = System.today().addDays(30);
        
        insert testOpp2;
    }

    @isTest
    static void testSchedulable() {
        Test.startTest();
            OpportunitySchedulable testOppSched = new OpportunitySchedulable();
            testOppSched.execute(null);
        Test.stopTest();
        

        Account acc = [SELECT Id, Is_Client__c FROM Account WHERE Name = 'Test Account' LIMIT 1];
        Assert.isTrue(acc.Is_Client__c, 'Account.Is_Client__c should be true.');
    }
}