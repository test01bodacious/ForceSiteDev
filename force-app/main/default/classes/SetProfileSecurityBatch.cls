public class SetProfileSecurityBatch implements Database.Batchable<sObject>{
    
    List<String> objNames;

    public SetProfileSecurityBatch(List<String> objNames) {
        this.objNames = objNames;
    }

    public Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator('SELECT Name FROM Profile__c');
    }

    public void execute(Database.BatchableContext bc, List<sObject> profilerecords){
       try {
           List<String> atNameList = new List<String>();
           List<Attachment> toInsertLst = new List<Attachment>();
           List<Attachment> toUpdateLst = new List<Attachment>();
           Map<String, Attachment> atMap = New Map<String, Attachment>();
           for (Attachment a : [select name, body from attachment]) {
               atNameList.add(a.Name);
               atMAp.put(a.Name, a);
           }
            for (String ob : objNames) {
                List<String> fldLst = new List<String>();
                // Object__c objectName = [SELECT Fields_Developer_Name__c FROM object__c WHERE (developer_name__c = :ob AND View__C = 'All Records View')];
                // fldLst = (objectName.Fields_Developer_Name__c).split('; ');
                fldLst = getFieldList(ob);
                for (Sobject pro : profilerecords) {
                    Attachment at = new Attachment();
                    CheckPermission securt = new CheckPermission(ob, (String)pro.get('Name'), fldLst);
                    
                    String securtStr = JSON.serialize(securt);
                    
                    blob body = Blob.valueOf(securtStr);
                    at.Name = (String)pro.get('Name') + ob;
                    at.Body = body;
                    at.ParentId = pro.id;

                    if (atNameList.contains(at.Name)) {
                        at.id = atMap.get(at.name).id;
                        toUpdateLst.add(at);
                    }else {
                        toInsertLst.add(at);
                    }
                   
                }
        }
        insertAttachment(toInsertLst);
        updateAttachment(toUpdateLst);
        
       } catch (Exception e) {
           Apexpages.addMessage(new Apexpages.message(Apexpages.Severity.ERROR, e.getMessage()));
           System.debug(e.getMessage() + ' ===>> ' + e.getLineNumber());
       }

    }

    Public void insertAttachment(List<Attachment> atcmntList){

        Database.insert(atcmntList);
    }

public void updateAttachment(List<Attachment> atcmntLst){
    Database.update(atcmntLst);
}
    public void finish(Database.BatchableContext bc){

    }   

    public List<String> getFieldList(String obj){
        List<String> fldLst = new List<String>();
        Map<String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get(obj).getDescribe().fields.getmap();
        for(String s : fieldMap.keyset()){
            if(fieldmap.get(s).getDescribe().iscreateable())
            fldLst.add(fieldmap.get(s).getDescribe().name);           
            }
            return fldLst;
    }
}