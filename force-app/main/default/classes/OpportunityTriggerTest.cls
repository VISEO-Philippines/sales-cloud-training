@isTest
private class OpportunityTriggerTest {

    @testSetup
    static void setupData() {
        // Create an account and a contact
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        Contact con = new Contact(FirstName = 'Test', LastName = 'Contact', AccountId = acc.Id);
        insert con;
    }

    @isTest
    static void assignContactRoletoOpportunity() {
        // Retrieve account
        Account acc = [SELECT Id FROM Account WHERE Name = 'Test Account' LIMIT 1];

        Opportunity opp = new Opportunity(
            Name = 'Test Opp Contact Role',
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(30),
            AccountId = acc.Id
        );
        insert opp;

        // Run test
        Test.startTest();
        List<OpportunityContactRole> roles = [SELECT ContactId, OpportunityId, IsPrimary 
                                            FROM OpportunityContactRole 
                                            WHERE OpportunityId = :opp.Id];
        System.assertEquals(1, roles.size(), 'One OpportunityContactRole should be created');
        System.assertEquals(true, roles[0].IsPrimary, 'The contact role should be primary');
        Test.stopTest();
    }
}