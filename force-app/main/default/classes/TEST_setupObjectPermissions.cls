@isTest
public class TEST_setupObjectPermissions {

    public boolean PermissionsRead {get; set;}
    public boolean PermissionsEdit {get; set;}
    public boolean PermissionsCreate {get; set;}
    public boolean PermissionsDelete {get; set;}
        
    public TEST_setupObjectPermissions(){
        this.PermissionsRead = true;
        this.PermissionsEdit = true;
        this.PermissionsCreate = true;
        this.PermissionsDelete = true;
    }
        
    public void setAllFalse(){
        this.PermissionsRead = false;
        this.PermissionsEdit = false;
        this.PermissionsCreate = false;
        this.PermissionsDelete = false;
    }
}