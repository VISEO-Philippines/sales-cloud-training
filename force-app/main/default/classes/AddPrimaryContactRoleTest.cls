@isTest
private class AddPrimaryContactRoleTest {

    @isTest
    static void testAddPrimaryContactRole() {
        // create a test account
        Account testAccount = new Account(
            Name = 'Test Account'
        );
        insert testAccount;
        
        // create a test contact
        Contact testContact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Account = testAccount
        );
        insert testContact;

        // create a test opportunity
        Opportunity testOpp = new Opportunity(
            Name = 'Test Opp', 
            CloseDate = System.today().addDays(30), 
            StageName = 'Prospecting',
            AccountId = testAccount.Id
        );

        insert testOpp;

        // Create OpportunityContactRole to avoid query exception
        OpportunityContactRole testOppConRole = new OpportunityContactRole(
            OpportunityId = testOpp.Id,
            ContactId = testContact.Id,
            Role = 'Primary',
            IsPrimary = true
        );
        insert testOppConRole;

        Test.startTest();
            AddPrimaryContactRoleHandler.addPrimaryContactRole(new List<Opportunity>{testOpp});    
        Test.stopTest();

        OpportunityContactRole insertedOppConRole = [
            SELECT ContactId, IsPrimary 
            FROM OpportunityContactRole 
            WHERE OpportunityId = :testOpp.Id AND Role = 'Primary' 
            LIMIT 1
        ];
        
        Assert.areEqual(testContact.Id, insertedOppConRole.ContactId, 'Contact ID should match the ID of the Contact created.');
        Assert.isTrue(insertedOppConRole.IsPrimary, 'The contact role should be marked as primary.');
    }
}