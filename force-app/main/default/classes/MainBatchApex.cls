public class MainBatchApex implements Database.Batchable<Sobject>, DataBase.Stateful{
    private List<Sobject> recordsToProcess ;
    private String processName;
    private String errorMsg='';
    private String selectedObj;
    private Integer countSuccess;
    private Integer countFailure;
    
    public MainBatchApex(List<Sobject> cObjects, String process, String sObj){
        recordsToProcess=cobjects;
        processName=process;
        selectedObj = sObj;
        countSuccess = 0;
        countFailure = 0;
    }
    
    
    Public Iterable<Sobject> start(database.BatchableContext dbc){
        
        return  recordsToProcess;
        //return Database.getQueryLocator('SELECT id FROM Account WHERE Id In : recordsToProcess');
        
    }
    
    
    public void execute(Database.BatchableContext dbc , List<Sobject> scop){
            switch on processName {
                when 'delete' {     
                    deleteRecords(scop);
                }   
                when 'update' {     
                    updateRecords(scop);
                }
                when 'task' {       
                    createTask(scop);
                }
                when 'event' {        
                    createEvent(scop);
                }
            }
    }
    
    
    public void finish(Database.BatchableContext dbc){
        
        Messaging.SingleEmailMessage email=new Messaging.SingleEmailMessage();
        String[]toAdd=new string[]{UserInfo.getUserEmail()};
        String []ccAdd=new string[]{'pritamrajyadav9@gmail.com'};
        email.setToAddresses(toAdd);
        email.setCcAddresses(ccAdd);
        email.setSubject('Process Complete');
        if(errorMsg != ''){
            email.setHtmlBody('<br/>Records Succeeded: ' + String.valueOf(countSuccess) + '<br/><br/>Records Failed: ' + String.valueOf(countFailure) +  '<br/><br/>The process you started got the following errors:<br/><br/>' + errorMsg);
        }else{
            email.setPlainTextBody('<br/>The process you started has been completed successfully.<br/><br/>Records Succeeded: ' + String.valueOf(countSuccess) + '<br/><br/>Records Failed: ' + String.valueOf(countFailure));
        }
        email.setSenderDisplayName('Bodacious IT Hub');
        Messaging.Email[] emails = new messaging.Email[]{email};
            Messaging.sendEmail(emails);
        
    }
    private void updateRecords(List<Sobject> lst){
        
            if(Schema.getGlobalDescribe().get(selectedObj).getDescribe().isUpdateable()){
                Database.SaveResult[] srList = Database.update(lst, false);
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
                    //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, error));
                }else{
                    //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'All Records have been updated successfully.'));
                }
            }else{
                errorMsg += ('<b>Insufficient Privileges</b>: Please contact your Admin<br/><br/>');
            }
    }
    private void deleteRecords(List<Sobject> lst){
            if(Schema.getGlobalDescribe().get(selectedObj).getDescribe().isDeletable()){
                Database.DeleteResult[] drList = Database.delete(lst, false);
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
                    //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errorMsg));
                }else{
                    //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'All records have been deleted'));
                }
            }else{
                errorMsg += ('<b>Insufficient Privileges</b>: Please contact your Admin<br/><br/>');
            }
    }
    private void createTask(List<Sobject> lst){
 
            if(Schema.getGlobalDescribe().get('Task').getDescribe().isCreateable()){
                Database.SaveResult[] srList = Database.insert(lst, false);
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
                } 
                if(errorMsg != ''){
                    //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, error));
                }else{
                    //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'All Taks have been created successfully.'));
                }
            }else{
                errorMsg += ('<b>Insufficient Privileges</b>: Please contact your Admin<br/><br/>');
            }
    }
    
    private void createEvent(List<Sobject> lst){
        
            if(Schema.getGlobalDescribe().get('Event').getDescribe().isCreateable()){
                Database.SaveResult[] srList = Database.insert(lst, false);
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
                } 
                if(errorMsg != ''){
                    //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, error));
                }else{
                    //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'All Events have been created successfully.'));
                }
            }else{
                errorMsg += ('<b>Insufficient Privileges</b>: Please contact your Admin<br/><br/>');
            }
    }
    
}