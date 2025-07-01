public with sharing class OpportunityTriggerHandler {

    public static void createOpportunityContactRole(List<Opportunity> opportunityList) {

        Set<Id> opportunityAccountIds = new Set<Id>();
    
        for (Opportunity opp : opportunityList) {
            if(opp.AccountId <> null){
                opportunityAccountIds.add(opp.AccountId);
            }
        }
        
        if(opportunityAccountIds.isEmpty()){
            return;
        }

        List<OpportunityContactRole> opportunityContactRolesList = new List<OpportunityContactRole>();

        for(Contact con : [SELECT Id, AccountId FROM Contact WHERE AccountId IN : opportunityAccountIds LIMIT 1]) {
            opportunityContactRolesList.add(
                new OpportunityContactRole(
                    OpportunityId = opp.Id,
                    ContactId = con.Id,
                    Role = 'Business User',
                    IsPrimary = true) 
                );
            }
            insert opportunityContactRolesList;
    }      
}