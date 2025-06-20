public with sharing class ContactEventTriggerHandler {
    public static void publishLogContactCreation(List<Contact_Delete_Event__e> newContacts) {
        List<Contact_Delete_Log__c> contactToLogList = new List<Contact_Delete_Log__c>();
        Set<Id> accIdSet = new Set<Id>();
        List<Contact> deserializedContacts = new List<Contact>();

        // deserialize Contact_JSON__c field into Contact object
        for(Contact_Delete_Event__e event : newContacts) {
            try {
                Contact contactToLogDeserialized = (Contact)JSON.deserialize(event.Contact_JSON__c, Contact.class);
                
                // add into the list
                deserializedContacts.add(contactToLogDeserialized);
                
                // to get the account name
                if(contactToLogDeserialized.AccountId != null) {
                    accIdSet.add(contactToLogDeserialized.AccountId);
                }
            } catch (Exception e) {
                System.debug('Error during converting JSON to Contact: ' + e.getMessage());
                throw new AuraHandledException('There was a problem processing contact deletion. Please contact your administrator.');
            }
        }

        // map to get account name
        Map<Id, Account> accountMap = new Map<Id, Account>([
            SELECT Id, Name FROM Account WHERE Id IN :accIdSet
        ]);

        // log the Contact to the custom object 
        for(Contact conToLog : deserializedContacts) {
            String accountName = accountMap.containsKey(conToLog.AccountId) ? accountMap.get(conToLog.AccountId).Name : null;
            contactToLogList.add(new Contact_Delete_Log__c(
                Name = conToLog.FirstName + ' ' + conToLog.LastName,
                AccountName__c = accountName,
                AccountId__c = conToLog.AccountId,
                Deleted_By_UserId__c = UserInfo.getUserId(),
                Deleted_Date_Time__c = Datetime.now(),
                Email__c = conToLog.Email,
                FirstName__c = conToLog.FirstName,
                Id__c = conToLog.Id,
                LastName__c = conToLog.LastName            
            ));
        }

        insert contactToLogList;
    }
}