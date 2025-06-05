@isTest
private class LeadTriggerHandlerTest {

    @isTest
    static void handleConvertedFromLeadTest() {
        // create a test account
        Account testAccount = new Account(
            Name = 'Test Account'
        );
        insert testAccount;
        
        // create a test lead
        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'Lead',
            Company = 'Test Company',
            Status = 'Open - Not Contacted',
            LeadSource = 'Web'
        );
        insert testLead;

        LeadTriggerHandler.hasRun = false;

        Test.startTest();
            // Lead Conversion
            Database.LeadConvert leadConvert = new Database.LeadConvert();
            leadConvert.setLeadId(testLead.Id);
            leadConvert.setConvertedStatus('Closed - Converted');
            leadConvert.setAccountId(testAccount.Id);

            Database.LeadConvertResult leadConvertResult = Database.convertLead(leadConvert);
        Test.stopTest();

        // check if conversion is success
        Assert.isTrue(leadConvertResult.isSuccess(), 'Lead Conversion is Successful');

        Lead checkLead = [SELECT Id, IsConverted, ConvertedContactId FROM Lead WHERE Id =: testLead.Id];
        Assert.areNotEqual(null, checkLead.ConvertedContactId, 'Converted Contact Id should not be null');
        Assert.areEqual(true, checkLead.IsConverted, 'Lead should be converted');

        Contact convertedContact = [SELECT Id, Converted_From_Lead__c FROM Contact WHERE Id =: checkLead.ConvertedContactId];
        Assert.areEqual(convertedContact.Converted_From_Lead__c, true, 'Converted From Lead should be true');
    }
}