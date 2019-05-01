public class TEST_setupPermissions {

    public String objectName {get; set;}
    public String fieldName {get; set;}
    public TEST_setupFieldPermissions fields {get; set;}
    public TEST_setupObjectPermissions objects {get; set;}
        
    public TEST_setupPermissions(String objectName, String fieldName){
        this.objectName = objectName;
        this.fieldName = fieldName;
        this.fields = new TEST_setupFieldPermissions();
        this.objects = new TEST_setupObjectPermissions();
    }
        
    public String getFieldFullName(){
        return this.objectName + '.' + this.fieldName;
    }
        
    public boolean hasObjectPermissions(){
        return this.objects.PermissionsRead || this.objects.PermissionsEdit || this.objects.PermissionsCreate || this.objects.PermissionsDelete;
    }
}