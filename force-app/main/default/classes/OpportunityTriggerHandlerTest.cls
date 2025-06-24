@isTest
private class OpportunityTriggerHandlerTest {

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
            AccountId = testAccount.Id
        );
        insert testContact;

        Test.startTest();
            // create a test opportunity
            Opportunity testOpp = new Opportunity(
                Name = 'Test Opp', 
                CloseDate = System.today().addDays(30), 
                StageName = 'Prospecting',
                AccountId = testAccount.Id
            );
            insert testOpp;  
        Test.stopTest();

        List<OpportunityContactRole> insertedOppConRole = [
            SELECT ContactId, IsPrimary, OpportunityId, Role
            FROM OpportunityContactRole 
            WHERE OpportunityId = :testOpp.Id
        ];
        
        Assert.areEqual(1, insertedOppConRole.size(), 'There should be one OpportunityContactRole record.');
        Assert.areEqual(testContact.Id, insertedOppConRole[0].ContactId, 'Contact ID should match the ID of the Contact created.');
        Assert.areEqual(testOpp.Id, insertedOppConRole[0].OpportunityId, 'The Opportunity ID should match the ID of the Opportunity created.');
        Assert.isTrue(insertedOppConRole[0].IsPrimary, 'The contact role should be marked as primary.');
        Assert.areEqual('Primary', insertedOppConRole[0].Role, 'The Role should be Primary.');
    }
}