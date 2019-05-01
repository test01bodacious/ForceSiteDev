public class Accessibility {
    public Map<string,FieldAccess> fieldAccessibility {get;set;}
    public Map<string,Recordaccess> recordAccessibility {get;set;}
    public Map<string,Objectaccess> objectAccessibility {get;set;}
    Public String email {get;set;}
    public String profile {get;set;}
    
    public Accessibility(){
        fieldAccessibility=new Map<string,fieldaccess>();
        recordAccessibility=new Map<string,Recordaccess>();
        objectAccessibility=new Map<string,Objectaccess>() ;
    }
    
    public class FieldAccess{
        public Boolean hasReadAccess {get;set;}
        public Boolean hasEditAccess {get;set;}
        
    
    public FieldAccess(){
        hasReadAccess=false;
        hasEditAccess=false;
    }
    }
    public class RecordAccess{
        public Boolean hasReadAccess {get;set;}
        public Boolean hasEditAccess {get;set;}

        public RecordAccess(){
            hasReadAccess=false;
            hasEditAccess=false;
        }
    }
    public class ObjectAccess{
        public Boolean hasReadAccess {get;set;}
        public Boolean hasEditAccess {get;set;}
        public Boolean hasCreateAccess {get;set;}
        public Boolean hasDeleteAccess {get;set;}

        public ObjectAccess(){
            hasReadAccess=false;
            hasEditAccess=false;
            hasCreateAccess=false;
            hasDeleteAccess=false;

        }
    }
}