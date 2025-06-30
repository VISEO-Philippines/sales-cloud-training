@isTest
private class OpportunityTriggerHandlerTest {

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

    static final String TEST_USER_USERNAME = 'opptestuser@example.com'; 

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
            UserName = TEST_USER_USERNAME
        );
        insert u;
    }


    @isTest
    static void testTaskCreatedOnInsertWithProposalStage() {
    User testUser = [SELECT Id FROM User WHERE Username = :TEST_USER_USERNAME LIMIT 1];

        System.runAs(testUser) {
            Opportunity opp = new Opportunity(
                Name = 'Inserted Opp',
                StageName = 'Proposal/Price Quote',
                CloseDate = Date.today().addDays(10),
                OwnerId = testUser.Id
            );
            insert opp;
            Test.startTest();
            OpportunityTriggerHandler.generateTaskForOpportunityOwner(new List<Opportunity>{ opp }, null);
            Test.stopTest();

            List<Task> tasks = [SELECT Id, OwnerId, WhatId, ActivityDate FROM Task WHERE WhatId = :opp.Id];
            Assert.areEqual(1, tasks.size(), 'Exactly one Task should be created on insert');
            Assert.areEqual(Date.today().addDays(3), tasks[0].ActivityDate, 'Task due date should be 3 days from today');
            Assert.areEqual(testUser.Id, tasks[0].OwnerId, 'Task should be assigned to Opportunity Owner');
        }
    }

    @isTest
    static void testTaskCreatedOnUpdateWhenStageChangedToProposal() {
    User testUser = [SELECT Id FROM User WHERE Username = :TEST_USER_USERNAME LIMIT 1];
        System.runAs(testUser) {
            
            Opportunity opp = new Opportunity(
                Name = 'Updated Opp',
                StageName = 'Qualification',
                CloseDate = Date.today().addDays(15),
                OwnerId = testUser.Id
            );
            insert opp;
            Opportunity oldOpp = opp.clone();
            Map<Id, Opportunity> oldMap = new Map<Id, Opportunity>{ opp.Id => oldOpp };

            opp.StageName = 'Proposal/Price Quote';
            update opp;

            Test.startTest();
            OpportunityTriggerHandler.generateTaskForOpportunityOwner(new List<Opportunity>{ opp }, oldMap);
            Test.stopTest();

            List<Task> tasks = [SELECT Id, OwnerId, WhatId, ActivityDate FROM Task WHERE WhatId = :opp.Id];
            Assert.areEqual(1, tasks.size(), 'Exactly one Task should be created on stage change');
            Assert.areEqual(testUser.Id, tasks[0].OwnerId, 'Task should be assigned to Opportunity Owner');
            Assert.areEqual(Date.today().addDays(3), tasks[0].ActivityDate, 'Task due date should be 3 days from today');
        }
    }

    @isTest
    static void testNoTaskCreatedWhenStageIsNotProposal() {
        User testUser = [SELECT Id FROM User WHERE Username = :TEST_USER_USERNAME LIMIT 1];
        System.runAs(testUser) {
            Opportunity opp = new Opportunity(
                Name = 'Non-qualifying Opp',
                StageName = 'Qualification', // Should not trigger
                CloseDate = Date.today().addDays(5),
                OwnerId = testUser.Id
            );
            insert opp;

            Test.startTest();
            OpportunityTriggerHandler.generateTaskForOpportunityOwner(new List<Opportunity>{ opp }, null);
            Test.stopTest();

            List<Task> tasks = [SELECT Id FROM Task WHERE WhatId = :opp.Id];
            Assert.areEqual(0, tasks.size(), 'No task should be created for non-Proposal stage');
        }
    }


}