public with sharing class AccountTriggerHandler {

    public static void createDefaultContact(List<Account> newAccountToAssignList) {
        List<Contact> contactsToInsert = new List<Contact>();

        for(Account acc : newAccountToAssignList) {
            Contact conInsert = new Contact();
            conInsert.FirstName = 'Default';
            conInsert.LastName = 'Contact';
            conInsert.AccountId = acc.Id;
            contactsToInsert.add(conInsert);
        }
        insert contactsToInsert;
    }
}