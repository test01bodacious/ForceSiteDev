public  class MyUserDataFactory {
    public Site_User__c my;
    public MyUserDataFactory() {
         my=new Site_User__c(name='aniketraj8493@gmail.com',Profile_Name__C='System Administrator');
        insert my;
    }
}