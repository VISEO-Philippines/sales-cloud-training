public with sharing class OpportunityTriggerHandler {

    public static void createOpportunityContactRole(List<Opportunity> opportunityList) {

        Set<Id> accountIds = new Set<Id>();
        for(Opportunity opp : opportunityList){
            if(opp.AccountId != null){
                accountIds.add(opp.AccountId);
            }
        }

        if(accountIds.isEmpty()){
            return;
        }
        
        Map<Id, Contact> accountContactMap = new Map<Id, Contact>();
        for (Contact con : [SELECT Id, AccountId FROM Contact WHERE AccountId IN :accountIds]){
            if (!accountContactMap.containsKey(con.AccountId)){
                    accountContactMap.put(con.AccountId, con);
            }
        } 

        List<OpportunityContactRole> opportunityContactRolesList = new List<OpportunityContactRole>();
        for (Opportunity opp : opportunityList) {
            if (accountContactMap.containsKey(opp.AccountId)) {
                OpportunityContactRole ocr = new OpportunityContactRole(
                    OpportunityId = opp.Id,
                    ContactId = accountContactMap.get(opp.AccountId).Id,
                    Role = 'Business User', 
                    IsPrimary = true
                );
                opportunityContactRolesList.add(ocr);
            }
        }
        insert opportunityContactRolesList;
    }      
}