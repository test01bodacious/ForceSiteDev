@isTest
public class TEST_setupFieldPermissions {

    public boolean PermissionsRead {get; set;}
    public boolean PermissionsEdit {get; set;}
        
    public TEST_setupFieldPermissions(){
        this.PermissionsRead = true;
        this.PermissionsEdit = true;
    }
}