public with sharing class LeadTriggerHandler {
    public static void convertHotWebLeads(List<Lead> leads) {
    Set<Id> leadIdsToCheck = new Set<Id>();

    // 1. Collect eligible Lead IDs first
    for (Lead lead : leads) {
        if (lead.Rating == 'Hot' && lead.LeadSource == 'Web') {
            leadIdsToCheck.add(lead.Id);
        }
    }

    // 2. Query fresh lead data (outside loop!)
    Map<Id, Lead> freshLeadMap = new Map<Id, Lead>(
        [SELECT Id, IsConverted, LeadSource, Rating FROM Lead WHERE Id IN :leadIdsToCheck]
    );

    List<Database.LeadConvert> leadConverts = new List<Database.LeadConvert>();
    Map<Id, Lead> leadIdToLeadMap = new Map<Id, Lead>();

    // 3. Convert only the leads that are NOT already converted
    for (Lead l : freshLeadMap.values()) {
        if (!l.IsConverted) {
            Database.LeadConvert lc = new Database.LeadConvert();
            lc.setLeadId(l.Id);
            lc.setDoNotCreateOpportunity(false);
            lc.setConvertedStatus('Closed - Converted');
            leadConverts.add(lc);
            leadIdToLeadMap.put(l.Id, l);
        }
    }

    System.debug('=== Original Leads === ' + leadIdToLeadMap);

    if (!leadConverts.isEmpty()) {
        List<Database.LeadConvertResult> results = Database.convertLead(leadConverts, false);
        for (Database.LeadConvertResult result : results) {
            if (!result.isSuccess()) {
                System.debug('Lead conversion failed: ' + result.getErrors());
            }
        }
        handleConvertedLeads(results, leadIdToLeadMap);
    }
}


    public static void handleConvertedLeads(List<Database.LeadConvertResult> results, Map<Id, Lead> leadIdToLeadMap) {
        //get the converted leads' ids and their corresponding contact ids
        List<Contact> contactToUpdate = new List<Contact>();
        for(Database.LeadConvertResult result : results){
            if(result.isSuccess()){
                Id leadId = result.getLeadId();
                System.debug('=== leadId ===' + leadId);
                Id convertedLeadContactId = result.getContactId();
                System.debug('=== converted Lead Contact ID ===' + convertedLeadContactId);
                if(leadId != null && convertedLeadContactId != null){
                    Lead originalLead = leadIdToLeadMap.get(leadId);
                    if (originalLead != null && originalLead.LeadSource != null){
                        contactToUpdate.add(new Contact(
                            Id = convertedLeadContactId,
                            Converted_From_Lead__c = leadId
                        ));                        
                    }
                }           
                }
            }
        
        System.debug('Contacts to be updated ' + contactToUpdate);
        //update the field Converted_From_Lead__c on contact')
        if(!contactToUpdate.isEmpty()){
            update contactToUpdate;
        }
    }
}