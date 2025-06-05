@isTest
private class OpportunityTriggerHandlerTest {

    @testSetup
    static void testData(){
        Account testAccount = new Account(); 
        testAccount.Name = 'Test Account';
        
        insert testAccount;

        Opportunity testOpp = new Opportunity();
        testOpp.Name = 'Test Opp'; 
        testOpp.StageName = 'Closed Won';
        testOpp.AccountId = testAccount.Id;
        testOpp.CloseDate = System.today().addDays(30);
        
        insert testOpp;
    }

    @isTest
    static void testBatchExecution() {
        
        Test.startTest();
            OpportunityScheduleHandler testOppSched = new OpportunityScheduleHandler();
            Database.executeBatch(testOppSched, 1);
        Test.stopTest();
    
        Account acc = [SELECT Id, Is_Client__c FROM Account LIMIT 1];
        Assert.areEqual(true, acc.Is_Client__c, 'Account.Is_Client__c should be true.');
    }

    @isTest
    static void testSchedulable() {
        Test.startTest();
            OpportunitySchedulableClass testOppSched = new OpportunitySchedulableClass();
            String chron = '0 0 0 * * ?';
            System.schedule('Test Opportunity Sched', chron, testOppSched);
        Test.stopTest();
    }

    @isTest
    static void testQueueable() {
        Test.startTest();
            OpportunityQueueableClass testOppQ = new OpportunityQueueableClass();
            System.enqueueJob(testOppQ);
        Test.stopTest();
    }
}