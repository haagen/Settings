/*

	Settings.cls

	Author: Martin Haagen
			martin@4front.se

	Description: 
		This is a class to simplify the usage of Custom Settings to handle org
		specific data. Designed to quickly provide the values of custom setting 
		without needing to instanciate any classes. 

		Methods will throw a SettingsException up on failure. 

	Examples:

		string AccountName = (string) Settings.get('NameOfAccount');
	
		This will provide you with the value of the custom setting called "NameOfAccount"

		List<string> AccountNames (List<string>) Setting.getList('AccountNames');

		This will provide you with a order list of string containing the values
		of the custom setting called "AccountNames_1", "AccountNames_2", "AccountNames_3"...

*/
public class Settings {

	private static List<Settings__c> settings = null;
	private static Set<string> availableTypes = new Set<string>{'Text', 'Textarea', 'Url', 'Phone', 'Email', 'Percent', 'Number', 'Currency', 'Date', 'Datetime', 'Boolean'};

	/*

		get

		Description:
			Will give you the value of one custom setting.

		Params:
			name - the name of the setting
		Returns:
			object - the value of the setting

	*/
	public static object get(string name) {
	 	Settings__c setting = getSetting(name);

	 	if (setting == null) {
	 		throw new SettingsException('Setting ' + name + ' has not been created in the "Settings" custom setting');
	 	}
		if (setting.Type__c == null) {
			throw new SettingsException('Setting Type is not defined');
		}	

		string type = captialize(setting.Type__c.replace('[]', '').toLowerCase());
		if(!availableTypes.contains(type)) {
			throw new SettingsException('Unknown settings type: ' + type);
		}
	 	return setting.get('setting' + type + '__c');
	}

	/*

		getList

		Description:
			Will provide an ordered list containing all of the values related to the
			setting with the excplicit name. 

		Params:
			name - the name of the setting
		Return
			List<object> - the values related to the existing setting

	*/
	public static List<object> getList(string name) {
	 	List<object> result = new List<object>();

		if(settings == null) {
			loadSettings();
		}

		integer idx = 0;
		Map<integer, object> tempMap = new Map<integer, object>();
		for (Settings__c setting : settings) {
			if (setting.Name.startsWith(name + '_') && setting.Type__c != null && setting.Type__c.endsWith('[]')) {				
				try {
					idx = integer.valueOf(setting.Name.substringAfterLast(name + '_'));
				} catch (System.Exception Ex) {
					continue;
				}
				tempMap.put(idx, get(setting.Name));
			}
		}	 

		// Fix the ordering of the elemetns
		List<integer> ordering = new List<integer>(tempMap.keySet());
		ordering.sort();
		for (integer i : ordering) {
			result.add(tempMap.get(i));
		}

		return result;	
	}




	/*
	 * Common helper methods
	 */
	@TestVisible		
	private static string captialize(string name) {
	 	if (name == null || name.length() == 0) {
	 		return name;
	 	}

	 	if (name.length() == 1) {
	 		return name.toUpperCase();
	 	}

	 	return name.substring(0, 1).toUpperCase() + name.substring(1, name.length()).toLowerCase();
	}

	private static void loadSettings() {
		if (settings == null) {
			settings = Settings__c.getAll().values();
		}		
	}

	private static Settings__c getSetting(string name) {
		loadSettings();
		for (Settings__c setting : settings) {
			if (setting.Name == name) {
				setting.Type__c = setting.Type__c != null ? setting.Type__c.toLowerCase() : null;
				return setting;
			}
		}
		return null;
	}

	public class SettingsException extends Exception {}
}