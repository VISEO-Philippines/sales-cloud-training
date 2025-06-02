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
                System.debug('Lead converted: ' + leadConvertResultList);
            }
        }
    }
    
    public static void checkForConvertedLeads(List<Lead> convertedLeadsList, Map<Id, Lead> oldLeadsMap){
	Set<Id> convertedFromLeads = new Set<Id>();
	List<Contact> contactsToUpdate = new List<Contact>();
    Map<Id, Id> contactIdFromConversion = new Map<Id, Id>();
     
        for(Lead cLeads : convertedLeadsList) {
            System.debug('Check List' + cLeads);
            System.debug('Check List' + oldLeadsMap.get(cLeads.Id));

            if(cLeads.IsConverted && oldLeadsMap.get(cLeads.Id).ConvertedContactId == null && cLeads.ConvertedContactId != null){
                convertedFromLeads.add(cLeads.ConvertedContactId);
                System.debug('Converted Contact Id' + cLeads.ConvertedContactId);
                contactIdFromConversion.put(cLeads., cLeads.Id);
				System.debug('Converted Contact Id' + cLeads.IdConvertedContactId);	
            }
        }
        
        List<Contact> contactFromLead = [SELECT Id, Converted_From_Lead__c FROM Contact WHERE Id IN :convertedFromLeads];
        
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