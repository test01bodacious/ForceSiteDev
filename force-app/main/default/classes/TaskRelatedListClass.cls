public class TaskRelatedListClass {
        
        private static TaskRelatedListClass instance = null;
        public boolean isTable {get; set;}
        public boolean isGlobalTable {get; set;}
        public boolean isChatter {get; set;}
        public boolean isCreate {get; set;}
        public boolean isHome {get; set;}
        public boolean isLoggedIn {get; set;}
        public boolean isPagination {get; set;}
        public boolean isTask {get; set;}
        public String userId {get ;set;}
        public list<String> taskRelatedObject {get; set;}
        public String accessToken {get; set;}
        public Site_User__c siteUser {get; set;}
        
        public TaskRelatedListClass(){
            siteUser = new Site_User__c();
            accessToken = '';
            taskRelatedObject = new List<string>();
            taskRelatedObject.add('account__c');
            taskRelatedObject.add('contact__c');
            taskRelatedObject.add('idt_products__c');
            userId = '';
            isTable = false;
            isGlobalTable = false;
            isChatter = false;
            isCreate = false;
            isHome = false;
            isLoggedIn = false;
            isPagination = false;
            isTask = false;
        }
        
        public static TaskRelatedListClass getInstance(){
            if(instance == null)
                instance = new TaskRelatedListClass();
            return instance ;
        }
    
    }