public with sharing class ContactTriggerHandler {
    public static void publishEventContactDeletion(List<Contact> deletedContacts) {
        List<Contact_Delete_Event__e> contactToPublishList = new List<Contact_Delete_Event__e>();
        
        for (Contact con : deletedContacts) {
            contactToPublishList.add(new Contact_Delete_Event__e( 
                Contact_JSON__c = JSON.serialize(con)
            ));
        }

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