trigger ContactDeleteEventTrigger on Contact_Delete__e (after insert) {
    List<Contact_Delete_Log__c> logs = new List<Contact_Delete_Log__c>();

    for (Contact_Delete__e event : Trigger.new) {
        logs.add(new Contact_Delete_Log__c(
            Contact__c = Id.valueOf(event.ContactId__c),
            Account_Name__c = event.Account_Name__c,
            Name__c = event.First_Name__c + ' ' + event.Last_Name__c,
            Email__c      = event.Email__c,
            Phone__c      = event.Phone__c
        ));
        System.debug('Contact: ' + event.ContactId__c );
        System.debug('Account Name: ' + event.Account_Name__c);
        System.debug('Name: ' + event.First_Name__c + ' ' + event.Last_Name__c);
        System.debug('Email: ' + event.Email__c + ', Phone: ' + event.Phone__c);
    }
    System.debug('Logs to insert' + logs);
    if (!logs.isEmpty()) {
        insert logs;
    }
}
