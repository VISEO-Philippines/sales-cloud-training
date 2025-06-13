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

     @isTest
    static void testUpdateToHotWebLeads() {
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

        // Create a test Opportunity record not yet in "Hot Web Leads"
        Opportunity testOpp = new Opportunity(
            Name = 'Test Opportunity',
            StageName = 'Prospecting',
            CloseDate = Date.today().addMonths(1),
            LeadSource = 'Web',
            AccountId = [SELECT Id FROM Account LIMIT 1].Id // Assuming there's at least one Account
        );
        insert testOpp;

        // Update the Opportunity to "Hot Web Leads"
        testOpp.StageName = 'Hot Web Leads';
        update testOpp;

        // Explicitly call the method 
        Test.startTest();
        LeadTriggerHandler.convertHotWebLeads(new List<Lead>{ testLead });
        Test.stopTest();

        // Re-query to assert conversion
        testLead = [
            SELECT Id, IsConverted, ConvertedContactId 
            FROM Lead 
            WHERE Id = :testLead.Id
        ];
        System.assertEquals(true, testLead.IsConverted, 'Lead should be converted');

        // Validate contact update
        Contact convertedContact = [
            SELECT Id, Converted_From_Lead__c 
            FROM Contact 
            WHERE Id = :testLead.ConvertedContactId
        ];
        System.assertEquals(testLead.Id, convertedContact.Converted_From_Lead__c, 
            'Converted contact should reference the original lead ID.');
    }
}