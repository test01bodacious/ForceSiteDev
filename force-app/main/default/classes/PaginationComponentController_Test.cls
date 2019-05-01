@isTest
public class PaginationComponentController_Test {
    @isTest
    public static void BubblewrapSetController(){
        PaginationComponentController pageCcontroller=new PaginationComponentController();
        pageCcontroller.setControllerBirthday=Datetime.newInstance(2008, 12, 1, 12, 30, 2);
        pageCcontroller.BubblewrapSetController();
    }
}