public class LeadTriggerHandler {

    public static void convertHotWebLeads(List<Lead> leadsToConvertList, Map<Id, Lead> oldLeadsMap) {
    List<Database.LeadConvert> leadConvertList = new List<Database.LeadConvert>();   

        for(Lead lead : leadsToConvertList) {
            if(!lead.IsConverted && lead.Rating == 'Hot' && lead.LeadSource == 'Web' &&
               ((oldLeadsMap.containsKey(lead.Id) && oldLeadsMap.get(lead.Id).Rating != 'Hot' || oldLeadsMap.get(lead.Id).LeadSource != 'Web') ||
                oldLeadsMap == NULL)) {
                Database.LeadConvert leadConvert = new Database.LeadConvert();
                leadConvert.setLeadId(lead.Id);
                leadConvert.setDoNotCreateOpportunity(true);
                leadConvert.setConvertedStatus('Closed - Converted');
                leadConvertList.add(leadConvert);
            }

            if(!leadConvertList.isEmpty()){
                List<Database.LeadConvertResult> leadConvertResultList = Database.convertLead(leadConvertList);
            }
        }
    }
}