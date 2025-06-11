public with sharing class AccountTriggerHandler {

    public static void createDefaultContact(List<Account> newAccountToAssignList) {
        List<Contact> contactsToInsert = new List<Contact>();

        for(Account acc : newAccountToAssignList) {
            contactsToInsert.add(new Contact(
                FirstName = 'Default',
                LastName = 'Contact',
                AccountId = acc.Id
            ));
        }
        insert contactsToInsert;
    }
}