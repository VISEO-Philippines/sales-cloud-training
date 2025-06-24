public with sharing class LeadTriggerHandler {

    public static void handleConvertedFromLead(List<Lead> newLeadList, Map<Id, Lead> oldLeadMap) {

        Set<Id> contactIdsToProcess = new Set<Id>();
        // To link the converted lead Ids to the new contact Ids
        Map<Id, Id> leadIdToConvertedContactId = new Map<Id, Id>();
        
        for (Lead lead : newLeadList) {
            // get old versions to compare
            Lead oldLead = oldLeadMap.get(lead.Id);
            
            if (lead.IsConverted && !oldLead.IsConverted) {
                // check if the leadSource is not blank and contact id is not null
                if(String.IsNotBlank(lead.LeadSource) && lead.ConvertedContactId != null) {
                    contactIdsToProcess.add(lead.ConvertedContactId);
                    // store to map the lead id and converted contact id
                    leadIdToConvertedContactId.put(lead.ConvertedContactId, lead.Id);
                }
            }
        }

        if(!contactIdsToProcess.isEmpty()) {
            List<Contact> contactsToUpdate = new List<Contact>();

            // query existing contact records based on the Ids
            Map<Id, Contact> existingContacts = new Map<Id, Contact>([
                SELECT Id, Converted_From_Lead__c
                FROM Contact 
                WHERE Id IN :contactIdsToProcess
            ]);

            for (Id contactId : existingContacts.keySet()) {
                Contact relatedContact = existingContacts.get(contactId);
                Id leadId = leadIdToConvertedContactId.get(contactId);
                
                if(relatedContact != null && relatedContact.Converted_From_Lead__c == null) {
                    relatedContact.Converted_From_Lead__c = String.valueOf(leadId);
                    contactsToUpdate.add(relatedContact);
                }
            }
            update contactsToUpdate;
        }
    }
}