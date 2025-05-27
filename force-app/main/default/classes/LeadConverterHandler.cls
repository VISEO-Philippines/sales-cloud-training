public with sharing class LeadConverterHandler {
	public static void convertHotWebLeads(List<Lead> leads) {
        List<Database.LeadConvert> leadConverts = new List<Database.LeadConvert>();

        for (Lead lead : leads) {
            if ((!lead.IsConverted) && (lead.Rating == 'Hot' && lead.LeadSource == 'Web')) {
                Database.LeadConvert lc = new Database.LeadConvert();
                lc.setLeadId(lead.Id);
                lc.setDoNotCreateOpportunity(false); 
                lc.setConvertedStatus('Closed - Converted'); 
                leadConverts.add(lc);
            }
        }
        
        List<Database.LeadConvertResult> results = Database.convertLead(leadConverts, false);
            for (Database.LeadConvertResult result : results) {
                if (!result.isSuccess()) {
                    System.debug('Lead conversion failed: ' + result.getErrors());
                }
        }
               
    }
}