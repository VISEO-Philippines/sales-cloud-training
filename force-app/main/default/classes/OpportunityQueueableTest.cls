@isTest
private class OpportunityQueueableTest {

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
    static void testQueueable() {
        Test.startTest();
            OpportunityQueueableClass testOppQ = new OpportunityQueueableClass();
            System.enqueueJob(testOppQ);
        Test.stopTest();
    }
}