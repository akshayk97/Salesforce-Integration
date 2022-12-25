public with sharing class userSendController {
    
    @AuraEnabled(cacheable=true)
    public static List<User> getUsers(String str){
        try {
            String keyStr = '%'+str+'%';
            return [SELECT Id, Name, Email 
                    FROM User WHERE Name like:keyStr Order by Name Limit 10];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static void createUsers(List<String> conObj){

        List<User> userObjItem = new   List<User>();

        // Profile p=[Select Id,Name from Profile where Name='Chatter Free User'];

        List<User> userObjList = [SELECT Id, FirstName, LastName, Alias,
                                 EmailEncodingKey, Username, ProfileId, 
                                 LocaleSidKey, LanguageLocaleKey, Email,Profile.Name  
                                 FROM User WHERE Id IN:conObj];
		
        List<UserDetailWrapper> usrwrapper = new List<UserDetailWrapper>();
        
        for(User usr : userObjList){
            UserDetailWrapper usrwrap = new UserDetailWrapper();
            usrwrap.alias = usr.Alias;
            usrwrap.Firstname = usr.FirstName;
            usrwrap.Lastname = usr.LastName;
            usrwrap.Emailencodingkey = usr.EmailEncodingKey;
            usrwrap.username = usr.Username;
            usrwrap.localesidkey = usr.LocaleSidKey;
            usrwrap.languagelocaleKey = usr.LanguageLocaleKey;
            usrwrap.eemail = usr.Email;
            usrwrap.profile = usr.Profile.Name;
            usrwrapper.add(usrwrap);

        }
        
        String usrliststr = JSON.serialize(usrwrapper);
        SendUserToOrg(usrliststr);

        system.debug(userObjList); 

    }

        //public static void SendUserToOrg(User usr){
		 public static void SendUserToOrg(String usr){
        Http http = new Http();
        
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:SFDCB/services/apexrest/ak2397/CasesTest');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;Charset=UTF-8');
       // request.setBody('{"alias":"'+usr.Alias+'", "Lastname":"'+usr.LastName+'", "Emailencodingkey":"'+usr.EmailEncodingKey+'", "username":"'+usr.Username+'", "localesidkey":"'+usr.LocaleSidKey+'", "languagelocaleKey":"'+usr.LanguageLocaleKey+'", "eemail":"'+usr.Email+'","profile":"'+usr.Profile.Name+'"}');
		request.setBody(usr);
       	system.debug('request body ' + usr);
        HttpResponse response = http.send(request);
        System.debug('&*&*&*&*&*'+response);
        
        // If the request is successful.
        if (response.getStatusCode() == 200) {
            System.debug(response.getBody());
        }
    }
    public class UserDetailWrapper {

        public String alias;
        public String Firstname;
        public String Lastname;
        public String Emailencodingkey;
        public String username;
        public String localesidkey;
        public String languagelocaleKey;
        public String eemail;
        public String profile;

    }
    
}