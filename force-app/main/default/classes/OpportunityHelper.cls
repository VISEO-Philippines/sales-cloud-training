public with sharing class OpportunityHelper {

    public static void sendAlertForWonOpps(List<Opportunity> closedWonOppList) {

        List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>();
        String kevEmail = 'tebs.guyo@gmail.com';

        for (Opportunity opp : closedWonOppList) {
            if (opp.IsClosed && opp.StageName == 'Closed Won' && opp.Amount > 500000) {
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();

                if (opp.Owner != null && opp.Owner.Email != null) {
                    email.setToAddresses(new String[] { opp.Owner.Email });
                } else {
                    email.setToAddresses(new String[] { kevEmail });
                }

                email.setSubject('Opportunity: ' + opp.Name + ' has been set to ClosedWon');
                email.setPlainTextBody('Opportunity: ' + opp.Name + ' has been changed to ClosedWon with Amount: ' + opp.Amount);
                messages.add(email);
            }
        }

        if (!messages.isEmpty()) {
            Messaging.sendEmail(messages);
        }
    }
}