
@isTest
private class LeadTriggerHandlerTest {

    @isTest
    static void testConvertHotWebLeads() {
        
        Lead newLeadRec = new Lead(
            FirstName = 'Keira',
            LastName = 'Bantot',
            Company = 'KCG Inc'
        );
        insert newLeadRec;

        newLeadRec.LeadSource = 'Web';
        newLeadRec.Rating = 'Hot';

        Test.startTest();
        update newLeadRec;
        Test.stopTest();

        List<Contact> result = [SELECT Id, Name FROM Contact WHERE FirstName = 'Keira' AND LastName = 'Bantot' LIMIT 1];
        System.assertEquals(1, result.size(), 'These should be 1 Contact Created after Convertion');
    
    }
}
