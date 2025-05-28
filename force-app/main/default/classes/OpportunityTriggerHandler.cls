public with sharing class OpportunityTriggerHandler {

    public static void createOpportunityContactRole(List<Opportunity> opportunityList) {

        List<OpportunityContactRole> opportunityContactRolesList = new List<OpportunityContactRole>();
        Set<Id> opportunityAccountIds = new Set<Id>();

        for(Opportunity opp:opportunityList){
            if(opp.AccountId <> null){
                opportunityAccountIds.add(opp.AccountId);
            }
        }
        
        List<Contact> contactList = [SELECT Id, AccountId FROM Contact where AccountId IN : opportunityAccountIds];
        
        for (Opportunity opp : opportunityList) {
            for(Contact con :contactList) {
            opportunityContactRolesList.add(
                new OpportunityContactRole(
                    OpportunityId = opp.Id,
                    ContactId = con.Id,
                    Role = 'Business User',
                    IsPrimary = true) 
                );
            }
        }
        insert opportunityContactRolesList; 
    }
}
