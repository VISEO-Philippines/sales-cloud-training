public class LeadTriggerHandler {

    public static void convertHotWebLeads(List<Lead> leadsToConvertList) {
    List<Database.LeadConvert> leadConvertList = new List<Database.LeadConvert>();   

        for(Lead lead : leadsToConvertList) {
            if(!lead.IsConverted && lead.LeadSource == 'Web' && lead.Rating == 'Hot'){
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

        List<Contact> contactFromLead = [SELECT Id, Converted_From_Lead__c FROM Contact WHERE Id IN :contactIdFromConversion.keySet()];
        
        for(Contact con : contactFromLead){
            con.Converted_From_Lead__c = contactIdFromConversion.get(con.Id);
            contactsToUpdate.add(con);
        }
        
        if(!contactsToUpdate.isEmpty())
        {
            update contactsToUpdate;
        }
        	        
    }
}