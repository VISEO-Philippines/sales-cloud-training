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

        List<Contact> result = [SELECT Id, Name FROM Contact WHERE FirstName = 'Keira' AND LastName = 'Bantot'];
        System.assertEquals(1, result.size(), 'These should be 1 Contact Created after Convertion');
    
    }

    @isTest
    static void testCheckForConvertedLeads() {
        
        Lead newLeadRec = new Lead(
            FirstName = 'Keira',
            LastName = 'Bantot',
            Company = 'KCG Inc',
            LeadSource = 'Web'
            
        );
        insert newLeadRec;

        newLeadRec.Rating = 'Hot';
        update newLeadRec;

        newLeadRec.LeadSource = 'Web';

        List<Lead> testLeadList = new List<Lead>();
        testLeadList.add(newLeadRec);
        Map<Id, Lead> oldLeadsMap = new Map<Id, Lead>();
        oldLeadsMap.put(newLeadRec.Id, newLeadRec);

        Test.startTest();
        LeadTriggerHandler.checkForConvertedLeads(testLeadList, oldLeadsMap);
        Test.stopTest();

        List<Contact> result = [SELECT Id, Name, Converted_From_Lead__c FROM Contact WHERE FirstName = 'Keira' AND LastName = 'Bantot'];
        System.assertEquals(1, result.size(), 'These should be 1 Contact Created after Convertion with Lead Id of: ' + result[0].Converted_From_Lead__c);
    
    }
}