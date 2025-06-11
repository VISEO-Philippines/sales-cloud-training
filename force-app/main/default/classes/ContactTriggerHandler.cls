public with sharing class ContactTriggerHandler {
    
    public static void addAssignTask(List<Contact> conToAssignTaskList) {
        List<Task> tasksToInsert = new List<Task>();

        for(Contact con : conToAssignTaskList) {
            tasksToInsert.add(
                new Task(
                    OwnerId = con.OwnerId,
                    Status = 'Not Started',
                    Subject = 'Task for ' + con.AccountId, 
                    WhoId = con.Id,
                    WhatId = con.AccountId,
                    Priority = 'Normal',
                    ActivityDate = Date.today().addDays(30)
                )
            );
        }
        insert tasksToInsert;
    }
}