@isTest
private class Settings_test {
	
	@isTest static void testSingleSetting() {
		
		List<Settings__c> lstSettings = new List<Settings__c>();
       	lstSettings.add(new Settings__c(name = 'text', type__c = 'text', settingText__c = 'Test Setting'));
       	lstSettings.add(new Settings__c(name = 'textarea', type__c = 'textarea', settingTextarea__c = 'This is a long text area'));
        lstSettings.add(new Settings__c(name = 'url', type__c = 'url', settingUrl__c = 'http://www.google.com'));
        lstSettings.add(new Settings__c(name = 'phone', type__c = 'phone', settingPhone__c = '+1234567890'));
        lstSettings.add(new Settings__c(name = 'email', type__c = 'email', settingEmail__c = 'name@domain.com'));
        lstSettings.add(new Settings__c(name = 'percent', type__c = 'percent', settingPercent__c = 12.23));
        lstSettings.add(new Settings__c(name = 'number', type__c = 'number', settingNumber__c = 12));
        lstSettings.add(new Settings__c(name = 'currency', type__c = 'currency', settingCurrency__c = 23.12));
        lstSettings.add(new Settings__c(name = 'date', type__c = 'date', settingDate__c = Date.today()));
        lstSettings.add(new Settings__c(name = 'datetime', type__c = 'datetime', settingDatetime__c = Datetime.newInstance(2012, 12, 12, 12, 12, 12)));
        lstSettings.add(new Settings__c(name = 'boolean', type__c = 'boolean', settingBoolean__c = true));
        lstSettings.add(new Settings__c(name = 'boom'));
        lstSettings.add(new Settings__c(name = 'boom2', type__c = 'Bogus'));
        insert lstSettings;

        test.startTest();

        // Test string types - positive
        System.assertEquals('Test Setting', Settings.get('text'));
        System.assertEquals('This is a long text area', Settings.get('textarea'));
        System.assertEquals('http://www.google.com', Settings.get('url'));
        System.assertEquals('+1234567890', Settings.get('phone'));
        System.assertEquals('name@domain.com', Settings.get('email'));

        // Test decimal types - positive
        System.assertEquals(12.23, Settings.get('percent'));
        System.assertEquals(12, Settings.get('number'));
        System.assertEquals(23.12, Settings.get('currency'));

        // Test date and datetime - positive
        System.assertEquals(Date.today(), Settings.get('date'));
        System.assertEquals(Datetime.newInstance(2012, 12, 12, 12, 12, 12), Settings.get('datetime'));

        // Test boolean - positive
        System.assertEquals(true, Settings.get('boolean'));

        // Test string type - negative
        Boolean excepted = false;
        try {
            string out = (string) Settings.get('percent');
        } catch (System.Exception Ex) {
            excepted = true;        
        }
        System.assert(excepted);
        excepted = false;
        try {
            string out = (string) Settings.get('boom');
        } catch (System.Exception Ex) {
            excepted = true;    
        }
        System.assert(excepted);

        // Test decimal type - negative
        excepted = false;
        try {
            decimal out = (decimal) Settings.get('date');
        } catch (System.Exception Ex) {
            excepted = true;        
        }
        System.assert(excepted);
        excepted = false;
        try {
            decimal out = (decimal) Settings.get('boom');
        } catch (System.Exception Ex) {
            excepted = true;        
        }
        System.assert(excepted);

        // Test date and datetime types - negative
        excepted = false;
        try {
            Date out = (Date) Settings.get('datetime');
        } catch (System.Exception Ex) {
            excepted = true;    
        }
        System.assert(excepted);
        excepted = false;
        try {
            Date out = (Date) Settings.get('boom');
        } catch (System.Exception Ex) {
            excepted = true;    
        }
        System.assert(excepted);
        excepted = false;
        try {
            Datetime out = (Datetime) Settings.get('text');
        } catch (System.Exception Ex) {
            excepted = true;    
        }
        System.assert(excepted);
		excepted = false;
        try {
            Datetime out = (Datetime) Settings.get('boom');
        } catch (System.Exception Ex) {
            excepted = true;    
        }
        System.assert(excepted);

		// Test boolean type - negative
        excepted = false;
        try {
            Boolean out = (Boolean) Settings.get('text');
        } catch (System.Exception Ex) {
            excepted = true;    
        }
        System.assert(excepted);
        excepted = false;
        try {
            Boolean out = (Boolean) Settings.get('boom');
        } catch (System.Exception Ex) {
            excepted = true;    
        }
        System.assert(excepted);

        // Non existing setting or bad type
        excepted = false;
        try {
        	Boolean out = (Boolean) Settings.get('nonexisting');
        } catch (System.Exception Ex) {
        	excepted = true;	
        }
        System.assert(excepted);
        excepted = false;
        try {
        	Boolean out = (Boolean) Settings.get('boom2');
        } catch (System.Exception Ex) {
        	excepted = true;	
        }
        System.assert(excepted);

        test.stopTest();
	}
	
	@isTest static void testListSettings() {
        List<Settings__c> lstSettings = new List<Settings__c>();

        lstSettings.add(new Settings__c(name = 'text_1', type__c = 'text[]', settingText__c = 'Test Setting (1)'));
        lstSettings.add(new Settings__c(name = 'text_2', type__c = 'text[]', settingText__c = 'Test Setting (2)'));
        lstSettings.add(new Settings__c(name = 'text_3', type__c = 'text[]', settingText__c = 'Test Setting (3)'));
        lstSettings.add(new Settings__c(name = 'boom_sture', type__c = 'text[]'));
        insert lstSettings;

        test.startTest();

        // Test string types - positive        
        System.assertEquals(3, Settings.getList('text').size());
        System.assertEquals('Test Setting (1)', Settings.getList('text')[0]);
        System.assertEquals('Test Setting (2)', Settings.getList('text')[1]);
        System.assertEquals('Test Setting (3)', Settings.getList('text')[2]);

        // Test - negative to catch Exceptions handlers
        System.assertEquals(0, Settings.getList('boom').size());

        test.stopTest();
	}

	@isTest static void testUnitTestMethods() {

		// capitalize
		System.assertEquals(null, Settings.captialize(null));
		System.assertEquals('', Settings.captialize(''));
		System.assertEquals('P', Settings.captialize('p'));
		System.assertEquals('Testcase', Settings.captialize('TESTCASE'));

	}
	
}