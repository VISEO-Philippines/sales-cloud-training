@IsTest
public class OpportunityHelperTest {

    @IsTest
    static void testSendEmailAfterOppClosedWonWithSpecificAmount() {

        Opportunity opp1 = new Opportunity(
            Name = 'Small Deal',
            StageName = 'Closed Won',
            CloseDate = Date.today(),
            Amount = 560000
        );

        Opportunity opp2 = new Opportunity(
            Name = 'Big Deal',
            StageName = 'Closed Won',
            CloseDate = Date.today(),
            Amount = 600000
        );

        Opportunity opp3 = new Opportunity(
            Name = 'Open Deal',
            StageName = 'Closed Won',
            CloseDate = Date.today(),
            Amount = 1000000
        );
        List<Opportunity> opportunities = new List<Opportunity>{ opp1, opp2, opp3 };
        insert opportunities;

        Test.startTest();
        OpportunityHelperClass.sendEmailAfterOppClosedWonWithSpecificAmount(opportunities, null);
        Test.stopTest();

        // assert if atleast 1 email has been sent
        Assert.areEqual(1, Limits.getEmailInvocations(), 'One email should be sent');
    }
}

   