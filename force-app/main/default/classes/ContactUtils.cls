public class ContactUtils {
    
    public static Integer getOppsFromContact(){
        Set<Id> accountIds = new Set<Id>();
        
        for(Contact con : [SELECT Id, AccountId FROM Contact WHERE AccountId != null]){
            accountIds.add(con.AccountId);
        }
        return [SELECT COUNT() FROM Opportunity WHERE AccountId IN: accountIds];
    }
}