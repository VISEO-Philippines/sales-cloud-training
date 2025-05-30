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
        // Trigger will auto-convert this based on your logic
        Test.stopTest();
        // Reload the lead and confirm it's converted
        testLead = [SELECT Id, IsConverted, ConvertedContactId FROM Lead WHERE Id = :testLead.Id];
        System.assertEquals(testLead.IsConverted, true, 'Lead should now be converted');

        // Re-query the converted contact
        Contact convertedContact = [
            SELECT Id, Converted_From_Lead__c 
            FROM Contact 
            WHERE Id = :testLead.ConvertedContactId
        ];

        // Assert the custom field is populated correctly
        System.assertEquals(testLead.Id, convertedContact.Converted_From_Lead__c, 
            'Converted contact should reference the original lead ID.');
    }
   
}