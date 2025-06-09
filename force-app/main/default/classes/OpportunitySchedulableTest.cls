@isTest
private class OpportunitySchedulableTest {

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
    static void testSchedulable() {
        Test.startTest();
            OpportunitySchedulableClass testOppSched = new OpportunitySchedulableClass();
            String chron = '0 0 0 * * ?';
            System.schedule('Test Opportunity Sched', chron, testOppSched);
        Test.stopTest();
    }
}