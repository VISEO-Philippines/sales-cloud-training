public with sharing class ContactTriggerHandler {
    public static void publishContactDeletion(List<Contact> deletedContacts) {
        List<Contact_Delete_Event__e> contactToPublishList = new List<Contact_Delete_Event__e>();
        List<Contact_Delete_Log__c> contactToLogList = new List<Contact_Delete_Log__c>();

        Set<Id> accIds = new Set<Id>();
        for (Contact con : deletedContacts) {
            accIds.add(con.AccountId);
        }

        for (Contact con : deletedContacts) {
            // to custom event Contact_Delete_Event__e
            contactToPublishList.add(new Contact_Delete_Event__e( 
                Contact_AccountId__c = con.AccountId,
                Contact_AccountName__c = con.Account.Name,
                Contact_Email__c = con.Email,
                Contact_FirstName__c = con.FirstName,
                Contact_Id__c = con.Id,
                Contact_LastName__c = con.LastName, 
                Deleted_Date_Time__c = System.now(),
                Deleted_By_UserId__c = UserInfo.getUserId()
            ));
            // to custom object Contact_Delete_Log__c
            contactToLogList.add(new Contact_Delete_Log__c( 
                AccountId__c = con.AccountId,
                AccountName__c = con.Account.Name,
                Email__c = con.Email,
                FirstName__c = con.FirstName,
                Id__c = con.Id,
                LastName__c = con.LastName,
                Deleted_Date_Time__c = System.now(),
                Deleted_By_UserId__c = UserInfo.getUserId()
            ));
        }
        insert contactToLogList;

        // Call method to publish events
        List<Database.SaveResult> results = EventBus.publish(contactToPublishList);

        // Inspect publishing result
        for (Database.SaveResult sr : results) {
            if (sr.isSuccess()) {
                System.debug('Successfully published event.');
            } else {
                for(Database.Error err : sr.getErrors()) {
                    System.debug('Error publishing ContactDeletedEvent__e: ' + err.getStatusCode() + ' - ' + err.getMessage());
                }
            } 
        }
    }
}