public class AccountTriggerHandler {

    public static void createContactWithAccountName (List<Account> newAccounts){
	List<Contact> conWithAccName = new List<Contact>();
	List<Task> tasksToCreate = new List<Task>();
    Set<Id> conWithAccNames = new Set<Id>();
        
        for(Account acc : newAccounts){
			
			//create contact
            Contact con = new Contact();
                con.FirstName = 'Default Contact';
                con.LastName = acc.Name;
                con.AccountId = acc.Id;
            	con.Email = 'wayaw@gmail.com';
            	conWithAccName.add(con);
           
            //create task
            Task t = new Task();
                t.ActivityDate = Date.newInstance(2025, 6, 30);
            	t.Description = 'test create task';
            	t.WhoId = con.Id;
                t.WhatId = acc.Id;
				t.Priority = 'Normal';
				t.Subject = 'Call';
            	tasksToCreate.add(t);
            }
        	insert conWithAccName;
        	insert tasksToCreate;
    }
}