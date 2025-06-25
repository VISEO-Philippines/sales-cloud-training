public with sharing class LeadTriggerHandler {
    // >>>>>>>>>>>>>>>>>>>>>> US-1
    public static void convertLeads(List<Lead> leadsToConvertList) {
        // store the lead which will be converted
        List<Lead> filteredLeads = new List<Lead>();

        // initialize the list to hold leads that meet the criteria
        for(Lead lds : leadsToConvertList) {
            if(lds.LeadSource == 'Web' && lds.Rating == 'Hot') {
                filteredLeads.add(lds);
            }
        }

        if(filteredLeads.isEmpty()) {
            return;
        }

        // list of lead records to convert
        List<Database.LeadConvert> leadConvertList = new List<Database.LeadConvert>();

        // add leads to the list if the lead meets the criteria
        for (Lead ldVar : filteredLeads) {
            Database.LeadConvert leadConvert = new Database.LeadConvert();
            leadConvert.setLeadId(ldVar.Id);
            leadConvert.setConvertedStatus('Closed - Converted');
            leadConvertList.add(leadConvert);
        }

        // conversion if the list is not empty
        if (!leadConvertList.isEmpty()) {
            List<Database.LeadConvertResult> leadConvertResultList =  Database.convertLead(leadConvertList);

            // checking if the lead converting was successful
            for(Database.LeadConvertResult lcrVar : leadConvertResultList) {
                if(lcrVar.isSuccess()) {
                    System.debug('Successfully converted lead with ID: ' + lcrVar.getLeadId());
                } else {
                    System.debug('Failed to convert lead with ID: ' + lcrVar.getLeadId());
                }
            }
        }
    }

    // >>>>>>>>>>>>>>>>>>>>>> US-3
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