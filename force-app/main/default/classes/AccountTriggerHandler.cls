public with sharing class AccountTriggerHandler {

    private static final String DEFAULT_CONTACT_FIRSTNAME = 'Acme';
    private static final String DEFAULT_TASK_SUBJECT = 'New Task';

    public static void createDefaultContactAndTaskForAccounts(List<Account> newAccounts) {
        if (newAccounts == null || newAccounts.isEmpty()) return;

        List<Contact> contactsToInsert = createContacts(newAccounts);

        try {
            insert contactsToInsert;
        } catch (DmlException e) {
            System.debug('Error inserting contacts: ' + e.getMessage());
            return;
        }

        //used to get ownerId
        Map<Id, Account> accountMap = new Map<Id, Account>();
        for (Account acc : newAccounts) {
            accountMap.put(acc.Id, acc);
        }

        List<Task> tasksToInsert = createTasks(contactsToInsert, accountMap);

        try {
            insert tasksToInsert;
        } catch (DmlException e) {
            System.debug('Error inserting tasks: ' + e.getMessage());
        }
    }

    private static List<Contact> createContacts(List<Account> accounts) {
        List<Contact> contacts = new List<Contact>();
        for (Account acc : accounts) {
            contacts.add(new Contact(
                FirstName = DEFAULT_CONTACT_FIRSTNAME,
                LastName = acc.Name,
                AccountId = acc.Id
            ));
        }
        return contacts;
    }

    private static List<Task> createTasks(List<Contact> contactsToInsert, Map<Id, Account> accountMap) {
        List<Task> tasks = new List<Task>();
        for (Contact contact : contactsToInsert) {
            Account acc = accountMap.get(contact.AccountId);
            if (acc != null) {
                tasks.add(new Task(
                    Subject = DEFAULT_TASK_SUBJECT,
                    WhatId = contact.AccountId,
                    WhoId = contact.Id,
                    OwnerId = acc.OwnerId
                ));
            }
        }
        return tasks;
    }
}
