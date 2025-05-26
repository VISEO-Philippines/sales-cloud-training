@isTest
private class AutoConvertLeadsTest {

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
            Assert.areEqual(true, cLead.IsConverted, 'Lead should have been converted.');
            Assert.areNotEqual(null, cLead.ConvertedAccountId, 'Converted Account ID should not be null.');
            Assert.areNotEqual(null, cLead.ConvertedContactId, 'Converted Contact ID should not be null.');
            Assert.areNotEqual(null, cLead.ConvertedOpportunityId, 'Converted Opportunity ID should not be null.');
        }
    }
}