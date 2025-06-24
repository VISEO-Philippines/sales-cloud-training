@isTest
public class LeadTriggerTest {

    @isTest
    static void testInsertedHotWebLeads() {
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

        Test.startTest();
        LeadTriggerHandler.convertHotWebLeads(new List<Lead>{ testLead }, null);
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


    @isTest
    static void testUpdateToHotWebLeads() {
        // Insert lead with non-qualifying values
        Lead nonHotLead = new Lead(
            FirstName = 'Test',
            LastName = 'Update',
            Company = 'UpdateCo',
            Rating = 'Warm',
            LeadSource = 'Other',
            Status = 'Open - Not Contacted'
        );
        insert nonHotLead;

        // Clone old lead to simulate oldMap
        Lead oldVersion = nonHotLead.clone();
        Map<Id, Lead> oldMap = new Map<Id, Lead>{ nonHotLead.Id => oldVersion };
        // Modify lead fields 
        nonHotLead.Rating = 'Hot';
        nonHotLead.LeadSource = 'Web';
        update nonHotLead;
        // Call handler directly to simulate trigger logic after update

        Test.startTest();
        LeadTriggerHandler.convertHotWebLeads(new List<Lead>{ nonHotLead }, oldMap);
        Test.stopTest();

        // Query the converted lead
        Lead updatedLead = [SELECT Id, IsConverted, ConvertedContactId FROM Lead WHERE Id = :nonHotLead.Id];
        System.assert(updatedLead.IsConverted, 'Lead should be converted after update');

        // Assert contact was created and linked
        Contact convertedContact = [
            SELECT Id, Converted_From_Lead__c 
            FROM Contact 
            WHERE Id = :updatedLead.ConvertedContactId
        ];
        System.assertEquals(nonHotLead.Id, convertedContact.Converted_From_Lead__c, 
            'Converted contact should reference the original lead ID.');
    }

}