@isTest
public class LeadTriggerTest {
    @isTest
    static void testConvertHotWebLeads() {
        // Create a test Lead
        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'Lead',
            Company = 'Test Company',
            Rating = 'Hot',
            LeadSource = 'Web',
            Status = 'Open - Not Contacted'
        );
        insert testLead;

        Test.startTest();
        testLead = [SELECT Id, IsConverted FROM Lead WHERE Id = :testLead.Id];
        System.assert(testLead.IsConverted, 'The lead should be converted.');
        Test.stopTest();
    }
}
