@isTest
public class ContactUtilsTest {
    
    @isTest
    static void testGetOpportunityCountByContact() {
        Account acc1 = new Account(Name = 'Test Account 1');
        Account acc2 = new Account(Name = 'Test Account 2');
        insert new List<Account>{ acc1, acc2 };
        
        Contact contact1 = new Contact(FirstName = 'John', LastName = 'Doe', AccountId = acc1.Id);
        Contact contact2 = new Contact(FirstName = 'Jane', LastName = 'Smith', AccountId = acc2.Id);
        Contact contact3 = new Contact(FirstName = 'No', LastName = 'Opps', AccountId = acc2.Id);
        insert new List<Contact>{ contact1, contact2, contact3 };

        Opportunity opp1 = new Opportunity(Name = 'Opp 1', StageName = 'Prospecting', CloseDate = Date.today().addDays(30), AccountId = acc1.Id);
        Opportunity opp2 = new Opportunity(Name = 'Opp 2', StageName = 'Proposal/Price Quote', CloseDate = Date.today().addDays(40), AccountId = acc1.Id);
        Opportunity opp3 = new Opportunity(Name = 'Opp 3', StageName = 'Negotiation/Review', CloseDate = Date.today().addDays(50), AccountId = acc2.Id);
        insert new List<Opportunity>{ opp1, opp2, opp3 };

        Test.startTest();
        List<Contact> contacts = [SELECT Id, AccountId FROM Contact];
        Map<Id, Integer> resultMap = ContactUtils.getOpportunityCountByContact(contacts);
        Test.stopTest();

        Assert.areEqual(2, resultMap.get(contact1.Id), 'Contact 1 should have 2 opps from acc1');
        Assert.areEqual(1, resultMap.get(contact2.Id), 'Contact 2 should have 1 opp from acc2');
        Assert.areEqual(1, resultMap.get(contact3.Id), 'Contact 3 shares acc2 and should also have 1 opp');

        Contact contactNoAcc = new Contact(FirstName = 'No', LastName = 'Account');
        insert contactNoAcc;
        contacts.add(contactNoAcc);

        resultMap = ContactUtils.getOpportunityCountByContact(contacts);
        Assert.areEqual(0, resultMap.get(contactNoAcc.Id), 'Contact with no Account should return 0 opps');
    }
}
