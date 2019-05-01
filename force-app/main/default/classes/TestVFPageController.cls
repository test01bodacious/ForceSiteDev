public class TestVFPageController {
    public String taskEventObj {get; set;}
    public List<String> recordIdLst {get; set;}
    Public UserInfo__C CustomUser {get; set;}
    public boolean isCreate {get; set;}
    public TestVFPageController(){
        isCreate = true;
        customUser = (UserInfo__c.getInstance('pritamraj.rits@gmail.com'));
        Apexpages.currentPage().getParameters().put('UserId', 'a010b00000f9kYQ');
    }

}