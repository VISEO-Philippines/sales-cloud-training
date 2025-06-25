@isTest
private class LeadTriggerHandlerTest {
    // >>>>>>>>>>>>>>>>>>>>>> US-1 Test
    @isTest
    static void testConvertLead() {
        List<Lead> testLeadsToCreateList = new List<Lead>();
        testLeadsToCreateList.add(new Lead( 
            FirstName = 'Test', 
            LastName = 'Lead1',
            Company = 'Test Company 1',
            LeadSource = 'Web',
            Rating = 'Hot'
        ));
        testLeadsToCreateList.add(new Lead( 
            FirstName = 'Test', 
            LastName = 'Lead2',
            Company = 'Test Company 2',
            LeadSource = 'Web',
            Rating = 'Hot'
        ));

        Test.startTest();
        insert testLeadsToCreateList;
        Test.stopTest();

        List<Lead> convertedLeadsList = [SELECT Id, IsConverted, ConvertedAccountId, ConvertedContactId, ConvertedOpportunityId FROM Lead WHERE Id IN :testLeadsToCreateList];

        Assert.areEqual(2, convertedLeadsList.size(), '2 leads should have been created.');

        for (Lead cLead : convertedLeadsList) {
            Assert.isTrue(cLead.IsConverted, 'Lead should have been converted.');
            Assert.isNotNull(cLead.ConvertedAccountId, 'Converted Account ID should not be null.');
            Assert.isNotNull(cLead.ConvertedContactId, 'Converted Contact ID should not be null.');
            Assert.isNotNull(cLead.ConvertedOpportunityId, 'Converted Opportunity ID should not be null.');
        }
    }

    // >>>>>>>>>>>>>>>>>>>>>> US-3 Test
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

        Lead checkLead = [SELECT Id, IsConverted, ConvertedContactId FROM Lead WHERE Id =: leadConvertResult.getLeadId()];
        Assert.isNotNull(checkLead.ConvertedContactId, 'Converted Contact Id should not be null');
        Assert.isTrue(checkLead.IsConverted, 'Lead should be converted');

        Contact convertedContact = [SELECT Id, Converted_From_Lead__c FROM Contact WHERE Id =: checkLead.ConvertedContactId];
        Assert.areEqual(testLead.Id, convertedContact.Converted_From_Lead__c, 'Converted From Lead should be true');
    }
}