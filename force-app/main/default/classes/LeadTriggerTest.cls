@isTest
public class LeadTriggerTest {

    @isTest
    static void testConvertHotWebLeadsExplicitCall() {
        // Create a test Lead record
        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'Lead',
            Company = 'Test Company',
            Rating = 'Hot',
            LeadSource = 'Web',
            Status = 'Open - Not Contacted'
        );
        insert testLead;

        // Explicitly call the method 
        Test.startTest();
        LeadTriggerHandler.convertHotWebLeads(new List<Lead>{ testLead });
        Test.stopTest();

        //Re-query to assert conversion
        testLead = [
            SELECT Id, IsConverted, ConvertedContactId 
            FROM Lead 
            WHERE Id = :testLead.Id
        ];
        System.assertEquals(true, testLead.IsConverted, 'Lead should be converted');

        //Validate contact update
        Contact convertedContact = [
            SELECT Id, Converted_From_Lead__c 
            FROM Contact 
            WHERE Id = :testLead.ConvertedContactId
        ];
        System.assertEquals(testLead.Id, convertedContact.Converted_From_Lead__c, 
            'Converted contact should reference the original lead ID.');
    }
}
