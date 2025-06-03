public with sharing class ContactTriggerHandler {
    
    public static void addAssignTask(List<Contact> newAccountList) {
        
        List<Task> tasksToInsert = new List<Task>();

        for(Contact con : newAccountList) {
            Task taskInsert = new Task();
            taskInsert.OwnerId = con.OwnerId;
            taskInsert.Status = 'Not Started';
            taskInsert.Subject = 'Follow up with Account: ' + con.AccountId; 
            taskInsert.WhoId = con.Id;
            taskInsert.WhatId = con.AccountId;
            taskInsert.Priority = 'Normal';
            taskInsert.ActivityDate = Date.today().addDays(30);
            tasksToInsert.add(taskInsert);
        }
        insert tasksToInsert;
    }
}