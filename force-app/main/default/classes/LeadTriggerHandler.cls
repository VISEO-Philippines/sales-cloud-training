public with sharing class LeadTriggerHandler {
    
    public static void convertHotWebLeads(List<Lead> leads) {
        Set<Id> eligibleLeadIds = getEligibleLeadIds(leads);

        if (eligibleLeadIds.isEmpty()) return;

        Map<Id, Lead> freshLeadMap = fetchFreshLeadsByIds(eligibleLeadIds);
        List<Database.LeadConvert> leadsToConvert = buildLeadConvertList(freshLeadMap);
        Map<Id, Lead> leadReferenceMap = mapLeadIdToLead(freshLeadMap);

        if (!leadsToConvert.isEmpty()) {
            List<Database.LeadConvertResult> conversionResults = Database.convertLead(leadsToConvert, false);
            logFailedConversions(conversionResults);
            updateConvertedContacts(conversionResults, leadReferenceMap);
        }
    }

    // === Identify eligible leads ===
    private static Set<Id> getEligibleLeadIds(List<Lead> leads) {
        Set<Id> leadIds = new Set<Id>();
        for (Lead lead : leads) {
            if (lead.Rating == 'Hot' && lead.LeadSource == 'Web') {
                leadIds.add(lead.Id);
            }
        }
        return leadIds;
    }

    // === Query fresh lead records ===
    private static Map<Id, Lead> fetchFreshLeadsByIds(Set<Id> leadIds) {
        return new Map<Id, Lead>(
            [SELECT Id, IsConverted, LeadSource, Rating FROM Lead WHERE Id IN :leadIds]
        );
    }

    // ===  Prepare convert requests ===
    private static List<Database.LeadConvert> buildLeadConvertList(Map<Id, Lead> leads) {
        List<Database.LeadConvert> convertList = new List<Database.LeadConvert>();

        for (Lead lead : leads.values()) {
            if (!lead.IsConverted) {
                Database.LeadConvert convertRequest = new Database.LeadConvert();
                convertRequest.setLeadId(lead.Id);
                convertRequest.setDoNotCreateOpportunity(false);
                convertRequest.setConvertedStatus('Closed - Converted');
                convertList.add(convertRequest);
            }
        }
        return convertList;
    }

    // ===  Map Lead ID to Lead for future reference ===
    private static Map<Id, Lead> mapLeadIdToLead(Map<Id, Lead> leads) {
        return new Map<Id, Lead>(leads);
    }

    // ===  Log any failed conversions ===
    private static void logFailedConversions(List<Database.LeadConvertResult> results) {
        for (Database.LeadConvertResult result : results) {
            if (!result.isSuccess()) {
                System.debug('Lead conversion failed: ' + result.getErrors());
            }
        }
    }

    // ===  Update converted Contact records ===
    private static void updateConvertedContacts(List<Database.LeadConvertResult> results, Map<Id, Lead> originalLeads) {
        List<Contact> contactsToUpdate = new List<Contact>();

        for (Database.LeadConvertResult result : results) {
            if (result.isSuccess()) {
                Id leadId = result.getLeadId();
                Id contactId = result.getContactId();

                if (leadId != null && contactId != null) {
                    Lead sourceLead = originalLeads.get(leadId);
                    if (sourceLead != null && sourceLead.LeadSource != null) {
                        contactsToUpdate.add(new Contact(
                            Id = contactId,
                            Converted_From_Lead__c = leadId
                        ));
                    }
                }
            }
        }

        if (!contactsToUpdate.isEmpty()) {
            update contactsToUpdate;
        }
    }
}
