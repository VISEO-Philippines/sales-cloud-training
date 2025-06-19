public with sharing class OpportunityHandler {
    public static void sendEmailNotification(List<Id> oppIds) {
        List<Opportunity> oppClosedWon = [
            SELECT Id, Name, Amount, StageName, Owner.Email, Owner.FirstName, Owner.LastName
            FROM Opportunity
            WHERE Id IN :oppIds AND StageName = 'Closed Won' AND Amount > 500000    
        ];

        List<Messaging.SingleEmailMessage> emailsToSend = new List<Messaging.SingleEmailMessage>();

        for(Opportunity opp : oppClosedWon) {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

            if(opp.OwnerId != null && String.isNotBlank(opp.Owner.Email)) {
                mail.setToAddresses(new String[] {opp.Owner.Email});
            } else {
                mail.setToAddresses(new String[] {'mico.calingasan@viseo.com'});
            }

            mail.setSubject('Opportunity Closed Won: ' + opp.Name);
            mail.setPlainTextBody('Hello ' + opp.Owner.FirstName + ' ' + opp.Owner.LastName +'.\n\n You have a new opportunity closed won.\n\n' + 'Opportunity Name: ' + opp.Name + '\n' + 'Opportunity Amount: $' + opp.Amount);
            mail.setSenderDisplayName('Email Alert');

            emailsToSend.add(mail); 
        }

        Messaging.sendEmail(emailsToSend);
        System.debug('emailsToSend: ' + emailsToSend);
    }
}