public with sharing class AutoConvertLeadsHandler {
    public static void convertLeads(List<Lead> leadsToConvertList) {
        // list of lead records to convert
        List<Database.LeadConvert> leadConvertList = new List<Database.LeadConvert>();

        // add leads to the list if the lead meets the criteria
        for (Lead ldVar : leadsToConvertList) {            
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