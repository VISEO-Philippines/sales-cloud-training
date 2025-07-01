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
    
    public static void checkLeadsIfConverted(List<Lead> leadsList, Map<Id, Lead> oldLeadsMap){

	List<Contact> contactsToUpdate = new List<Contact>();
    Map<Id, Id> contactIdFromConversion = new Map<Id, Id>();
     
        for(Lead cLeads : leadsList) {

            if(cLeads.IsConverted && oldLeadsMap.get(cLeads.Id).ConvertedContactId == null && cLeads.ConvertedContactId != null){
                contactIdFromConversion.put(cLeads.ConvertedContactId, cLeads.Id);	
            }
        }

        for(Contact con : [SELECT Id, Converted_From_Lead__c FROM Contact WHERE Id IN :contactIdFromConversion.keySet()]){
            con.Converted_From_Lead__c = contactIdFromConversion.get(con.Id);
            contactsToUpdate.add(con);
        }
        update contactsToUpdate;
        	        
    }
}