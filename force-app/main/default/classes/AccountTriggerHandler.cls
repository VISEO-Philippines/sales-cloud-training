public with sharing class AccountTriggerHandler {
    public static void handleAfterInsert(Map<Id, Account> accMap) {
        
        List<Task> taskList = new List<Task>();
        
        for (Account acc : accMap.values()) {
            Task task = new Task();
            task.Subject = 'New Task';
            task.WhatId = acc.Id;
            task.OwnerId = acc.OwnerId;


            if(!acc.Contacts.isEmpty()){
                task.WhoId = acc.Contacts[0].Id;
            }

            taskList.add(task);
        }

        if (!taskList.isEmpty()) {
            insert taskList;
        }
    }

    public static void relateTaskToContact(List<Contact> contactList){
        Set<Id> accountIds = new Set<Id>();
        for(Contact con : contactList){
                accountIds.add(con.AccountId);
            }

        List<Task> taskToUpdate = [
            SELECT Id, WhatId, WhoId    
            FROM Task 
            WHERE WhatId IN :accountIds AND WhoId = null
        ];
        
        for(Account  acc : [SELECT Id, (SELECT Id FROM Contacts LIMIT 1) FROM Account WHERE Id IN :accountIds]){
            if(!acc.Contacts.isEmpty()){
                for(Task t : taskToUpdate){
                    t.WhoId = acc.Contacts[0].Id;
                }
            }
        }
            update taskToUpdate;
    }
}