global class InsertSectionAndFieldBatch implements Database.Batchable<sObject>, Database.Stateful{  
      
    private List<sObject> recordsToProcess ;  
    private String operation;  
    private String errorMsg = '';  
    private String objectName;  
    private Integer countSuccess;  
    private Integer countFailure;  
      
    global InsertSectionAndFieldBatch( String objectName){  
        this.recordsToProcess = recordsToProcess;  
        this.objectName = objectName;  
        this.operation = opp;  
        this.countSuccess = 0;  
        this.countFailure = 0;  
    }  
      
    global Iterable<sObject> start(Database.batchableContext info){   
        return new SectionAndFieldIteratorClass(recordsToProcess);   
    }    
      
    global void execute(Database.batchableContext info, List<sObject> scope){  
        switch on operation {  
            when 'insertSection' {  
               CreateSectionAndField();
            }     
            when 'update' {       
                updateRecords(scope);
            }  
            when 'delete' {       
                deleteRecords(scope);
            }  
            when else {  
                 
            }  
        }  
    }   
      
    global void finish(Database.batchableContext info){       
        AsyncApexJob job = [SELECT CreatedBy.Email FROM AsyncApexJob WHERE Id = :info.getJobId()];  
        // Messaging.SendEmailResult[] results = sendEmail(job.CreatedBy.Email);  
        // for (Messaging.SendEmailResult result : results) {  
        //    if(result.isSuccess()){  
        //         System.debug('EMAIL SEND SUCCESFULLY');  
        //     }else{  
        //         String error = '';  
        //         for (Messaging.SendEmailError err: result.getErrors()) {  
        //             error += err.getMessage();  
        //         }  
        //         System.debug('ERROR SENDING EMAIL: ' + error);  
        //     }  
        // }  
    }

    public void insertRecords(List<sObject> records){  
  
            if(Schema.getGlobalDescribe().get(objectName).getDescribe().isCreateable()){  
                Database.SaveResult[] srList = Database.insert(records, false);  
                for(Database.SaveResult sr : srList) {  
                    if (sr.isSuccess()){  
                        countSuccess++;  
                    }  
                    else {  
                        countFailure++;  
                        for(Database.Error err : sr.getErrors()) {  
                            errorMsg += ('<b>' + err.getStatusCode() + '</b>: ' + err.getMessage()) + '<br/><br/>';  
                            if(err.getFields().size() > 0)  
                                errorMsg += ('Fields that affected this error: ' + err.getFields() + '<br/><br/>');  
                        }  
                    }  
                    System.debug('ERROR: ' + errorMsg);  
                }  
                if(errorMsg != ''){  
                      
                }else{  
                      
                }  
            }else{  
                errorMsg += ('<b>Insufficient Privileges</b>: Please contact your Admin<br/><br/>');  
            }  
    }  
      
    private void updateRecords(List<Sobject> records){  
          
            if(Schema.getGlobalDescribe().get(objectName).getDescribe().isUpdateable()){  
                Database.SaveResult[] srList = Database.update(records, false);  
                for(Database.SaveResult sr : srList) {  
                    if (sr.isSuccess()){  
                        countSuccess++;  
                    }  
                    else {  
                        countFailure++;  
                        for(Database.Error err : sr.getErrors()) {  
                            errorMsg += ('<b>' + err.getStatusCode() + '</b>: ' + err.getMessage()) + '<br/><br/>';  
                            if(err.getFields().size() > 0)  
                                errorMsg += ('Fields that affected this error: ' + err.getFields() + '<br/><br/>');  
                        }  
                    }  
                    System.debug('ERROR: ' + errorMsg);  
                }  
                if(errorMsg != ''){  
                      
                }else{  
                      
                }  
            }else{  
                errorMsg += ('<b>Insufficient Privileges</b>: Please contact your Admin<br/><br/>');  
            }  
    }  
  
    private void deleteRecords(List<Sobject> records){  
            if(Schema.getGlobalDescribe().get(objectName).getDescribe().isDeletable()){  
                Database.DeleteResult[] drList = Database.delete(records, false);  
                for(Database.DeleteResult dr : drList) {  
                    if (dr.isSuccess()){  
                        countSuccess++;  
                    }  
                    else {  
                        countFailure++;  
                        for(Database.Error err : dr.getErrors()) {  
                            errorMsg += ('<b>' + err.getStatusCode() + '</b>: ' + err.getMessage()) + '<br/><br/>';  
                            if(err.getFields().size() > 0)  
                                errorMsg += ('Fields that affected this error: ' + err.getFields() + '<br/><br/>');  
                        }  
                    }  
                }  
                if(errorMsg != ''){  
                      
                }else{  
                      
                }  
            }else{  
                errorMsg += ('<b>Insufficient Privileges</b>: Please contact your Admin<br/><br/>');  
            }  
    }  


        //// Section AND Field ////
    List<Section__c> sectionLst ;
    List<record_Type__C> recordTypeLst ;
    List<LayoutDescriberHelper.LayoutSection> layoutSections ;
    public  void CreateSectionAndField() {
        sectionLst = new List<Section__c>();
        recordTypeLst = new List<Record_type__C>();
        layoutSections = new List<LayoutDescriberHelper.LayoutSection>();
        initSection();
    }
      List<Section__c> updateSectionLst = new List<Section__c>();
      
    public void initSection(){
        sectionLst = new List<Section__c>();
        List<String> existingRecordType = new List<String>();
        try {
            // recordTypeLst = [SELECT Name, recordTypeId__c, Object__c, profile__r.Name, Object__R.Name, (SELECT id, name FROM Pagelayouts__r) FROM Record_Type__c];
            
            for (PageLayout__c rt : [SELECT PageLayoutid__C, Record_Type__r.recordTypeId__C, Profile__r.Name, Object__r.Developer_name__C, Name FROM Pagelayout__C ]) {
                
                if (!existingRecordType.contains(rt.Name)) {
                    existingRecordType.add(rt.name);
                    layoutSections = LayoutDescriberHelper.describeSectionWithFields(rt.record_Type__r.RecordTypeId__C, rt.Object__r.Developer_name__C, rt.profile__r.Name);
                    initSectionAndField(rt.id, rt.Object__R.Developer_name__C);
                    
                }
            }
            
            insertSectionAndField();
            updateSectionLst(updateSectionLst);
        } catch (Exception e) {
            APexpages.addMessage(new Apexpages.message(Apexpages.Severity.ERROR, e.getMessage() + '  ' + e.getCause() + '   ' + e.getLineNumber()));
        }
    }

    public void initSectionAndField(String s,  String obj){
       
        List<String> fldlst;
        List<String> existingSectionLst = new list<String>();
        Map<String, Section__C> sectionsMap = new Map<String, Section__c>();
        try {
            for (Section__C sec  : [SELECT Name, PageLayout__r.id FROM Section__C]) {
                existingSectionLst.add(sec.Name + sec.PageLayout__r.id);
                sectionsMap.put(sec.Name + sec.PageLayout__r.id, sec);
            }
            for (LayoutDescriberHelper.LayoutSection section : layoutSections) {
                Section__c sec  = new Section__C();
                sec.Name = section.Name;
                sec.column__c = section.columns;
                sec.pageLayout__C = s;
                sec.ObjectName__c  = obj;
                fldLst = new List<String>();
                
                for (LayoutDescriberHelper.LayoutField fld : Section.layoutFields) {
                    if(fld.ApiName.toLowerCase() == 'BillingAddress'){
                        fldLst.add('BillingStreet');
                        fldLst.add('BillingCity');
                        fldLst.add('BillingState');
                        fldLst.add('BillingPostalCode');
                        fldLst.add('BillingCountry');
                    } else if(fld.ApiName.toLowerCase() == 'ShippingAddress'){
                        fldLst.add('ShippingStreet');
                        fldLst.add('ShippingCity');
                        fldLst.add('ShippingState');
                        fldLst.add('ShippingPostalCode');
                        fldLst.add('ShippingCountry');
                    } else if (fld.ApiName.toLowerCase() == 'MailingAddress') {
                        fldLst.add('MailingStreet');
                        fldLst.add('MailingCity');
                        fldLst.add('MailingState');
                        fldLst.add('MailingPostalCode');
                        fldLst.add('MailingCountry');
                    } else if(fld.ApiName.toLowerCase() == 'OtherAddress') {
                        fldLst.add('OtherStreet');
                        fldLst.add('OtherCity');
                        fldLst.add('OtherState');
                        fldLst.add('OtherPostalCode');
                        fldLst.add('OtherCountry');
                    } else if (fld.ApiName.toLowerCase() == 'name' && obj.toLowerCase() == 'contact') {
                        fldLst.add('LastName');
                        fldLst.add('FirstName');
                    } else {
                        fldLst.add(fld.ApiName);
                    }
                    
                }
                sec.fields_developer_Name__c = String.join(fldLst, '; ');
                if(!existingSectionLst.contains(section.Name +s)){
                    sectionLst.add(sec);
                }else {
                    System.debug(sec);
                    sec.id = sectionsMap.get(section.Name +s).id;
                   
                      updateSectionLst.add(sec);
                }
            }
            
        } catch (Exception e) {
            Apexpages.addMessage(new apexpages.message(Apexpages.Severity.ERROR, e.getMessage() + ' line ==>  ' + e.getLineNumber()));
        }
    }
    

    public void updatesectionLst(List<Section__c> secLst){
        try {
           if (secLst != null) {
                dataBase.update(secLst, false);
           }
        } catch (Exception e) {
            Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, e.getMessage() + ' at line ' + e.getLineNumber()));
        }
    }
    Id batchJobId  ; 
    public void insertSectionAndField(){

        try {
            if (sectionLst != null && batchJobId != null) {
               // Database.insert(sectionLst, false);
                AsyncApexJob aap = [SELECT Status FROM AsyncApexJob WHERE Id = :batchJobId];  
                if(aap.Status == 'Completed' || aap.Status == 'Failed' || aap.Status == 'Aborted'){ 
                   batchJobId = Database.executeBatch(new InsertSectionAndFieldBatch(sectionLst, 'Section__C', 'insert'), 3000); 
                   System.debug(batchJobId);
                }
                else {
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Warning, 'The process is already going on. Please wait for sometime, untill it finishes'));  
                }
            }else {
                batchJobId = Database.executeBatch(new InsertSectionAndFieldBatch(sectionLst, 'Section__C', 'insert'), 3000);
            }
        } catch (Exception e) {
            Apexpages.addMessage(New Apexpages.message(Apexpages.Severity.ERROR, e.getMessage() + 'Line ==> ' + e.getLineNumber()));
            
        }
    }


}  
