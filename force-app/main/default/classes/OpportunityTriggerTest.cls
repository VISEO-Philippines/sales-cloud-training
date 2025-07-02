@isTest
private class OpportunityTriggerTest {

     @isTest
    static void assignContactRoleToOpportunity() {
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        Contact con = [SELECT Id FROM Contact WHERE AccountId = :acc.Id LIMIT 1];

        Opportunity opp = new Opportunity(
            Name = 'Test Opp Contact Role',
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(30),
            AccountId = acc.Id
        );
        insert opp;

        List<OpportunityContactRole> roles = [
            SELECT ContactId, OpportunityId, IsPrimary 
            FROM OpportunityContactRole 
            WHERE OpportunityId = :opp.Id
        ];

        System.assertEquals(1, roles.size(), 'One OpportunityContactRole should be created');
        System.assertEquals(true, roles[0].IsPrimary, 'The contact role should be primary');
        System.assertEquals(con.Id, roles[0].ContactId, 'The OpportunityContactRole should be linked to the auto-created Contact');
    }

        @testSetup
    static void setupTestUser() {
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];

        User u = new User(
            Alias = 'testu',
            Email = 'opptest@example.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Tester',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = p.Id,
            TimeZoneSidKey = 'Asia/Manila',
            UserName = 'opptestuser_' + System.currentTimeMillis() + '@example.com'
        );
        insert u;
    }

    @isTest
    static void testTaskCreatedOnInsertWithProposalStage() {
        User testUser = [SELECT Id FROM User WHERE LastName = 'Tester' LIMIT 1];
        System.runAs(testUser) {
            Opportunity opp = new Opportunity(
                Name = 'Inserted Opp',
                StageName = 'Proposal/Price Quote',
                CloseDate = Date.today().addDays(10),
                OwnerId = testUser.Id
            );
            insert opp;

            List<Task> tasks = [SELECT Id, OwnerId, WhatId, ActivityDate FROM Task WHERE WhatId = :opp.Id];
            System.assertEquals(1, tasks.size(), 'Exactly one Task should be created on insert');
            System.assertEquals(testUser.Id, tasks[0].OwnerId, 'Task should be assigned to Opportunity Owner');
            System.assertEquals(Date.today().addDays(3), tasks[0].ActivityDate, 'Task due date should be 3 days from today');
        }
    }

    @isTest
    static void testTaskCreatedOnUpdateWhenStageChangedToProposal() {
        User testUser = [SELECT Id FROM User WHERE LastName = 'Tester' LIMIT 1];
        System.runAs(testUser) {
            Opportunity opp = new Opportunity(
                Name = 'Updated Opp',
                StageName = 'Qualification',
                CloseDate = Date.today().addDays(15),
                OwnerId = testUser.Id
            );
            insert opp;

            opp.StageName = 'Proposal/Price Quote';
            update opp;

            List<Task> tasks = [SELECT Id, OwnerId, WhatId, ActivityDate FROM Task WHERE WhatId = :opp.Id];
            System.assertEquals(1, tasks.size(), 'Exactly one Task should be created on stage change');
            System.assertEquals(testUser.Id, tasks[0].OwnerId, 'Task should be assigned to Opportunity Owner');
            System.assertEquals(Date.today().addDays(3), tasks[0].ActivityDate, 'Task due date should be 3 days from today');
        }
    }
    

    @isTest
    static void deleteClosedWonOpportunityTest() {
        Opportunity opp = new Opportunity(
                    Name = 'Test Opp',
                    StageName = 'Closed Won',
                    CloseDate = Date.today()
                    );
        insert opp;
        
        Test.startTest();
        Database.DeleteResult result = Database.delete(opp, false);
        Test.stopTest();
        
        System.assert(!result.isSuccess());
        System.assert(result.getErrors().size() > 0);
        System.assertEquals('You can\'t delete Opportunity with StageName: Closed Won', result.getErrors()[0].getMessage());
    }
}