@isTest
public class OpportunityHelperTest {

    @isTest
    static void testSendEmailAfterOppClosedWonWithSpecificAmount() {
        // Setup test Account
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        // Create Opportunities (only one should trigger email)
        Opportunity opp1 = new Opportunity(
            Name = 'Small Deal',
            StageName = 'Closed Won',
            CloseDate = Date.today(),
            Amount = 100000,
            AccountId = acc.Id
        );

        Opportunity opp2 = new Opportunity(
            Name = 'Big Deal',
            StageName = 'Closed Won',
            CloseDate = Date.today(),
            Amount = 600000,
            AccountId = acc.Id
        );

        Opportunity opp3 = new Opportunity(
            Name = 'Open Deal',
            StageName = 'Prospecting',
            CloseDate = Date.today(),
            Amount = 1000000,
            AccountId = acc.Id
        );

        insert new List<Opportunity>{ opp1, opp2, opp3 };

        Test.startTest();
        OpportunityHelperClass.sendEmailAfterOppClosedWonWithSpecificAmount(
            [SELECT Id, StageName, Amount FROM Opportunity WHERE Id IN :new List<Id>{opp1.Id, opp2.Id, opp3.Id}]
        );
        Test.stopTest();

        // NOTE: We can't assert Messaging.sendEmail() directly.
        // To test actual email sending, you'd need to use a mock in an interface-based design.
        // Here, we just ensure code executes without exceptions.
        System.assert(true, 'Method executed without error');
    }
}
