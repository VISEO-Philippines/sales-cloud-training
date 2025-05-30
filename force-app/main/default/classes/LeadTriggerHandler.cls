public with sharing class LeadTriggerHandler {
    
    public static void convertLeads(List<Lead> leadsToConvertList) {
        // store the lead which will be converted
        List<Lead> filteredLeads = new List<Lead>();

        // initialize the list to hold leads that meet the criteria
        for(Lead lds : leadsToConvertList) {
            if(lds.LeadSource == 'Web' && lds.Rating == 'Hot') {
                filteredLeads.add(lds);
            }
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
}