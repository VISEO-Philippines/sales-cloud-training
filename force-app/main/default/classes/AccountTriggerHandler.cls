public with sharing class AccountTriggerHandler {

    public static void createContactAndTask(Map<Id, Account> accMap) {
        List<Contact> contactsToInsert = createContacts(accMap);
        insert contactsToInsert;

        List<Task> tasksToInsert = createTasks(accMap.keySet(), contactsToInsert);
        insert tasksToInsert;
    }

    private static List<Contact> createContacts(Map<Id, Account> accMap) {
        List<Contact> contactList = new List<Contact>();

        for (Account acc : accMap.values()) {
            contactList.add(new Contact(
                FirstName = 'acme',
                LastName = acc.Name,
                AccountId = acc.Id
            ));
        }

        return contactList;
    }

    private static List<Task> createTasks(Set<Id> accountIds, List<Contact> insertedContacts) {
        List<Task> taskList = new List<Task>();
        Map<Id, Contact> accountIdToContact = new Map<Id, Contact>();

        for (Contact con : insertedContacts) {
            accountIdToContact.put(con.AccountId, con);
        }

        for (Id accId : accountIds) {
            Task task = new Task(
                Subject = 'New Task',
                WhatId = accId,
                OwnerId = UserInfo.getUserId()
            );

            if (accountIdToContact.containsKey(accId)) {
                task.WhoId = accountIdToContact.get(accId).Id;
            }

            taskList.add(task);
        }

        return taskList;
    }
}
