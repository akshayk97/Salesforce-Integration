@RestResource(urlMapping='/CasesTest/*')
global class IntegrationWebService {
    @HttpPost
    global static Id createUser() {
        
        String reqbody = RestContext.request.requestBody.toString();
        system.debug('req body string ' + reqbody);
        List<UserDetailWrapper> usrwrapper = (List<UserDetailWrapper>)JSON.deserialize(reqbody, List<UserDetailWrapper>.class);
        system.debug('list wrapper ' + usrwrapper);
        
        List<User> profilesList = new List<User>();
        List<User> insertuser = new List<User>();
        
        // Need to fetch only profile                        
        profilesList = [SELECT Id, Profile.Name FROM User];
        
        Map<String,Id> fetchProfiles = new Map<String,Id>();
        for(User usrp : profilesList){
            fetchProfiles.put(usrp.Profile.Name, usrp.Profile.Id);
        }
        
        for(UserDetailWrapper uwrap : usrwrapper){
            Id profileid = fetchProfiles.get(uwrap.profile);
            UserDetailWrapper usrwrap = new UserDetailWrapper();
            User u = new User();
            u.Alias = uwrap.Alias;
            u.FirstName = uwrap.Firstname;
            u.Lastname = uwrap.Lastname;
            u.Emailencodingkey = uwrap.EmailEncodingKey;
            u.Username = uwrap.Username+'@integrationtesting.com';
            u.LocaleSidKey = uwrap.LocaleSidKey;
            u.LanguageLocaleKey = uwrap.LanguageLocaleKey;
            u.TimeZoneSidKey='America/Los_Angeles';
            u.Email = uwrap.eemail;
            u.ProfileId = profileid;
            //u.Profile.Name = uwrap.profile;
            insertuser.add(u);      
        }
        
        
        try{
            insert insertuser;
            System.debug('User Created -- ' + insertuser);
        }
        catch(Exception e){
            System.debug('Error:'+e.getMessage());
        }
        // return newUser.Id;
        return null;
    }
}
