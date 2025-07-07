public class AccountTriggerHandler {

    public static void createContactWithAccountName (List<Account> newAccountList){
	List<Contact> conWithAccNameList = new List<Contact>();
	List<Task> tasksToCreateList = new List<Task>();
    
    if(newAccountList.isEmpty()){
        return;
    }

        for(Account acc : newAccountList){
			
			//create contact
            Contact con = new Contact();
                con.FirstName = 'Default Contact';
                con.LastName = acc.Name;
                con.AccountId = acc.Id;
            	con.Email = 'wayaw@gmail.com';
            	conWithAccNameList.add(con);
    }
    insert conWithAccNameList;

        for(Contact con : conWithAccNameList){
            //create task
            Task t = new Task();
                t.ActivityDate = Date.newInstance(2025, 6, 30);
            	t.Description = 'test create task';
            	t.WhoId = con.Id;
                t.WhatId = con.AccountId;
				t.Priority = 'Normal';
				t.Subject = 'Call';
            	tasksToCreateList.add(t);
            }
               	insert tasksToCreateList;
        }
}