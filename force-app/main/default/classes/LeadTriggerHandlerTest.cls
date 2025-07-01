@isTest
private class LeadTriggerHandlerTest {

    static void testConvertHotWebLeads() {
        
        Lead newLeadRec = new Lead(
            FirstName = 'Keira',
            LastName = 'Bantot',
            Company = 'KCG Inc'
        );
        insert newLeadRec;

        Map<Id, Lead> oldLeadsMap = new Map<Id, Lead>([SELECT Id, Rating, LeadSource FROM Lead WHERE Id =: newLeadRec.Id]);

        newLeadRec.LeadSource = 'Web';
        newLeadRec.Rating = 'Hot';
        update newLeadRec;
        
        Test.startTest();
            LeadTriggerHandler.convertHotWebLeads(new List<Lead>{newLeadRec}, oldLeadsMap);
        Test.stopTest();

        List<Contact> result = [SELECT Id, Name FROM Contact WHERE FirstName = 'Keira' AND LastName = 'Bantot'];
        assert.areEqual(1, result.size(), 'These should be 1 Contact Created after Convertion');
    
    }
}