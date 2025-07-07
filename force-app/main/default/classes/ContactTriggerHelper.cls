public with sharing class ContactTriggerHelper {

    public static void logDeletedContact(List<Contact> contacts) {
        if (contacts == null || contacts.isEmpty()) {
            System.debug(LoggingLevel.WARN, '[ContactTriggerHelper] No contacts passed to logDeletedContact.');
            return;
        }

        // Collect AccountIds
        Set<Id> accountIds = new Set<Id>();
        for (Contact c : contacts) {
            if (c.AccountId != null) {
                accountIds.add(c.AccountId);
            }
        }

        // Query related Account names
        Map<Id, String> accountNameMap = new Map<Id, String>();
        if (!accountIds.isEmpty()) {
            for (Account acc : [
                SELECT Id, Name
                FROM Account
                WHERE Id IN :accountIds
            ]) {
                accountNameMap.put(acc.Id, acc.Name);
            }
        }

        // Prepare and publish Platform Events
        List<Contact_Delete__e> events = new List<Contact_Delete__e>();
        for (Contact c : contacts) {
            String accountName = accountNameMap.get(c.AccountId);

            System.debug(LoggingLevel.INFO, '[ContactTriggerHelper] Preparing delete event for Contact Id: ' + c.Id);
            System.debug(LoggingLevel.INFO, '  Account Name: ' + accountName);
            System.debug(LoggingLevel.INFO, '  First Name: ' + c.FirstName);
            System.debug(LoggingLevel.INFO, '  Last Name: ' + c.LastName);
            System.debug(LoggingLevel.INFO, '  Email: ' + c.Email);
            System.debug(LoggingLevel.INFO, '  Phone: ' + c.Phone);

            events.add(new Contact_Delete__e(
                ContactId__c      = c.Id,
                Account_Name__c   = accountName,
                First_Name__c     = c.FirstName,
                Last_Name__c      = c.LastName,
                Email__c          = c.Email,
                Phone__c          = c.Phone
            ));
        }

        if (!events.isEmpty()) {
            EventBus.publish(events);
            System.debug(LoggingLevel.INFO, '[ContactTriggerHelper] Published ' + events.size() + ' Contact_Delete__e events.');
        } else {
            System.debug(LoggingLevel.INFO, '[ContactTriggerHelper] No Contact_Delete__e events to publish.');
        }
    }
}
