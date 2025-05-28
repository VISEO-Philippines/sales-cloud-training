public with sharing class AddPrimaryContactRoleHandler {
    public static void AddPrimaryContactRole(List<Opportunity> newOpportunityList) {
        List<OpportunityContactRole> contactRolesToInsertList = new List<OpportunityContactRole>();
        // store the account Id to set [unique]
        Set<Id> accIds = new Set<Id>();

        // get Ids from opportunities
        for(Opportunity opp : newOpportunityList) {
            // check if the opportunity has account Id
            if(opp.AccountId != null) {
                accIds.add(opp.AccountId);
            }
        }

        // query contacts for accounts related to Opp
        List<Contact> contList = [SELECT Id, AccountId FROM Contact WHERE AccountId IN: accIds];
        
        // loop through opportunity and contacts to match and create a contact role
        for(Opportunity oppVar : newOpportunityList) {
            for(Contact conVar : contList) {
                if(conVar.AccountId == oppVar.AccountId) {
                    OpportunityContactRole conRole = new OpportunityContactRole(
                        OpportunityId = oppVar.Id,
                        ContactId = conVar.Id,
                        Role = 'Primary',
                        IsPrimary = true
                    );
                    contactRolesToInsertList.add(conRole);
                    // break; // stop when first contact is found
                }
            }
        }

        // insert if there are contact roles inside the list
        if(!contactRolesToInsertList.isEmpty()) {
            try {
                insert contactRolesToInsertList;
            } catch(DmlException e) {
                System.debug('Error occurred during insert of Contact Roles: ' + e.getMessage());
            }
        }

    }
}