public class ProfilePermissionPageController implements Queueable, Database.AllowsCallouts {
    
    List<Record_Type__c> pgLst;
    Map<String, LIST<Record_Type__c>> pgMap;
    public Map<String, ProfRTType> proRtMap {get;set;}
    
    public ProfilePermissionPageController(){
        pgLst = [SELECT Name, Object__r.Developer_Name__C,  Profile__r.Name, isPermitted__c FROM Record_Type__c ORDER BY Object__c];
        pgMap = new Map<String, List<Record_Type__c>>();
        List<Record_Type__c> pgl = new List<Record_Type__c>();
        List<Object__C> controlObjLst = [SELECT developer_Name__c FROM Object__C];
        for(Record_Type__c pg: pgLst){
            for (Object__C ob : controlObjLst) {
             
                if (ob.developer_Name__c == pg.Object__r.Developer_Name__C) {
                    if(pgMap.containsKey(pg.Object__r.Developer_Name__C)){
                        pgl.add(pg);
                        pgMap.put(pg.Object__r.Developer_Name__C, pgl);
                    }else{
                        pgl = new List<Record_Type__c>();
                        pgl.add(pg);
                        pgMap.put(pg.Object__r.Developer_Name__C, pgl);
                    }
                }
            }
        }
        initproRtMap();
    }
    
    public void initproRtMap(){
        proRtMap = new Map<String, ProfRTType>();
        for(String objName: pgMap.keySet()){
            ProfRTType prt = new ProfRTType();
            List<String> allRtNames = new List<String>();
            prt.rtWrapLst = getrtWrapLst(pgMap.get(objName), allRtNames);
            prt.profWrapLst = getprofWrapLst(pgMap.get(objName), allRtNames);
            proRtMap.put(objName, prt);
        }
    }

    
    public List<ProfileWrapper> getprofWrapLst(List<Record_Type__c> plLst, List<String> allRtNames){
        List<ProfileWrapper> pwList = new List<ProfileWrapper>();
        List<String> pfNames = new List<String>();
        for(Record_Type__c pl: plLst){
            if(!pfNames.contains(pl.Profile__r.Name)){
                pfNames.add(pl.Profile__r.Name);
                ProfileWrapper pw = new ProfileWrapper();
                pw.profileName = pl.Profile__r.Name;
                pw.prtLayout = getprtLayout(plLst, pw.profileName,  allRtNames);
                pwList.add(pw);
            }
        }
        return pwList;
    }

    public Map<String, PageLayoutWrapper> getprtLayout(List<Record_Type__c> plLst, String profileName,  List<String> allRtNames){
        Map<String, PageLayoutWrapper> prtLayoutMap = new Map<String, PageLayoutWrapper>();
        for (Record_Type__c pl : plLst) {
            if(pl.Profile__r.Name == profileName){
                PageLayoutWrapper plWrap = new PageLayoutWrapper();
                plWrap.isPermitted = pl.isPermitted__c;
                plWrap.sobj = pl;
                prtLayoutMap.put(pl.Name, plWrap);
            }
        }
        for (String rtName : allRtNames) {
            if(!prtLayoutMap.containsKey(rtName)){
                PageLayoutWrapper plWrap = new PageLayoutWrapper();
                plWrap.isPermitted = false;                
                prtLayoutMap.put(rtName, plWrap);
            }
        }
        return prtLayoutMap;
    }
    
    public List<RecordTypeWrapper> getrtWrapLst(List<Record_Type__c> plLst, List<String> allRtNames){
        List<RecordTypeWrapper> rtTypeWrapLst = new List<RecordTypeWrapper>();
        List<String> rtTypeName = new List<String>();
        for(Record_Type__c pl : plLst){
            if(!rtTypeName.contains(pl.Name)){
                rtTypeName.add(pl.Name);
                allRtNames.add(pl.Name);
                RecordTypeWrapper rtWrap = new RecordTypeWrapper();
                rtWrap.recordTypeName = pl.Name;
                rtTypeWrapLst.add(rtWrap);
            }
        }
        return rtTypeWrapLst;
    }

    public Pagereference save(){
        List<Record_Type__c> updatePgLst = new List<Record_Type__c>();
        try {
            for (String s : proRtMap.keySet()) {
                for (RecordTypeWrapper rt : proRtMap.get(s).rtWrapLst) {
                    for (ProfileWrapper prw : proRtMap.get(s).profWrapLst) {
                        if(prw.prtlayout.get(rt.recordTypeName).sobj != null){
                            prw.prtlayout.get(rt.recordTypeName).sobj.put('isPermitted__c', prw.prtlayout.get(rt.recordTypeName).isPermitted);
                            updatePgLst.add((Record_Type__c)prw.prtlayout.get(rt.recordTypeName).sobj); //.put('name', prw.prtlayout.get(rt.recordTypeName).selectedPlName)
                        }else {
                            //  prw.prtlayout.get(rt.recordTypeName).sobj = new Record_Type__c();
                            //  prw.prtlayout.get(rt.recordTypeName).sobj.put('Name', prw.prtlayout.get(rt.recordTypeName).selectedPlName);
                            // updatePgLst.add((Record_Type__c)prw.prtlayout.get(rt.recordTypeName).sobj); //.put('name', prw.prtlayout.get(rt.recordTypeName).selectedPlName)
                        }
                    }
                }
            }
            update updatePgLst;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Record Type Updated Successfully'));
            
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage() + ' Line Number ===>> ' + e.getLineNumber()));
        }
        return null;
    }
     string getUrlPrefix(){
        String baseurl = [SELECT InstanceName FROM Organization].InstanceName;
        return baseurl;
    }
public  String accessToken;

    public  void orgAuthentication(){
         GoogleAndConnectedAppCredentials__c credentials = GoogleAndConnectedAppCredentials__c.getInstance('Credential1');
            String grantType = 'password';
            String client_Id = credentials.OrgClientId__c;
            String client_secret = credentials.OrgClientSecret__c;
            String userName = credentials.OrgUserName__c;
            String password = credentials.OrgPassword__c;
            String securityToken = credentials.OrgSecurityToken__c;
            String instanceUrl = 'https://login.salesforce.com';
            String endPointUrl = instanceUrl + '/services/oauth2/token?grant_type=' + grantType + '&client_id=' + client_Id + '&client_secret=' + client_secret + '&username=' + userName + '&password=' + password + securityToken;
            Http h = new Http();
            HttpRequest req = new HttpRequest();
            req.setMethod('POST');
            req.setEndpoint(endPointUrl);
            HttpResponse res = h.send(req);
            String body = res.getBody();
            accessToken = String.valueOf(((Map<String, Object>)JSON.deserializeUntyped(body)).get('access_token'));
            
    }

id jobId;
    public  Pagereference goToPageLayOutPage(){
        if(jobId != null){
                AsyncApexJob aap = [SELECT Status FROM AsyncApexJob WHERE Id = :jobId];  
                if(aap.Status == 'Completed' || aap.Status == 'Failed' || aap.Status == 'Aborted'){ 
                    jobId = System.enqueueJob(this);
                    ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, 'The process is started, you\'ll be mailed when it is completed'));  
                }
                else {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Warning, 'The process is already going on. Please wait for sometime, untill it finishes'));  
                }
            }else {
                jobId = System.enqueueJob(this);
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, 'The process is started, you\'ll be mailed when it is completed'));  
            }
        Pagereference pgr = new Pagereference('/apex/PageLayouts');
        pgr.getParameters().put('jobId' , jobId);
       return pgr;
    }


public void pgaelayoutInsertionForbatch(){
        List<PageLayout__c> toInsertPageLayout  =  new List<PageLayout__c>();
        List<String> checkForPageLayout = new List<String>();
        String obj = '';
        String rtType ='';
        List<Pagelayout> pagLayoutLst = new List<PageLayout>();
        try {
            Map<String, Object__C> objMap = new Map<String, Object__C>();
            for(Object__c ob : [SELECT developer_Name__c FROM Object__C]){
                    objMap.put(ob.developer_Name__C, ob);
            }
            List<PageLayout__C> existingPageLayout = [SELECT Name, Object__r.Developer_Name__C, Profile__r.Name,  record_Type__r.Name FROM PageLayout__C];
            for (PageLayout__C playout : existingPageLayout) {
                checkForPageLayout.add(playout.Object__r.Developer_Name__C + playout.profile__r.name + playout.record_Type__r.Name);
                
            }
            List<Record_Type__c> recTypeLst = [SELECT Object__r.Developer_Name__c, Object__r.id, object__c, Profile__c,  Profile__r.Name, Name FROM record_Type__c  ORDER BY Object__r.developer_Name__C];
            for(Record_Type__c rt : recTypeLst){
               if(objMap.keyset().contains(rt.object__r.developer_Name__c)){
                    objMap.remove(rt.object__r.developer_Name__C);
               }
                if(rt.isPermitted__c = true){
                   
                    if (obj != rt.Object__r.Developer_Name__c + rt.Name) { //This is for prevent ob duplicate Object
                         pagLayoutLst =  getPageLayoutName(rt.Object__r.developer_Name__c);
                    }
                    obj = rt.Object__r.Developer_Name__c + rt.Name;
                    for (PageLayout s : pagLayoutLst) {
                        if (rtType != rt.profile__r.Name + rt.Name) {  //This is for prevent ob duplicate record Type
                            rtType = rt.profile__r.Name + rt.Name;
                            PageLayout__c pg = new PageLayout__c();
                            pg.object__c  =  rt.object__c;
                            pg.profile__c = rt.profile__c;
                            pg.Record_Type__c = rt.id;
                            if ((Schema.getGlobalDescribe().get(rt.Object__r.developer_Name__c).getdescribe().isCUstom())) {
                                pg.Name = s.Name;
                                pg.PageLayoutId__C = s.pgId;
                            }else {
                                 pg.Name =pagLayoutLst[pagLayoutLst.size()-1].Name;
                                 pg.PageLayoutId__C = (id)pagLayoutLst[pagLayoutLst.size()-1].pgId;
                            }
                           
                             
                            String str = rt.Object__r.Developer_Name__c + rt.profile__r.Name + rt.Name ;
                            if(!checkForPageLayout.contains(str)){
                                toInsertPageLayout.add(pg);
                            }
                        }
                    }
                }else {
                    PageLayout__c pg = new PageLayout__c();
                    pg.object__c  =  rt.object__c;
                    pg.profile__c = rt.profile__c;
                    pg.Record_Type__c = rt.id;
                    //pg.Name = getPageLayoutName(rt.Object__r.developer_Name__c);
                }
                
            }
            initPGLForWithoutRcTypeObj(objMap, toInsertPageLayout);
            insert toInsertPageLayout;
        } catch (Exception e) {
             System.debug('Exception in class: ' + String.valueOf(this).split(':')[0] + ' === Message: ' + e.getMessage() + ' === At Line: ' + e.getLineNumber());
        }
}

public void initPGLForWithoutRcTypeObj(Map<String, Object__C> objMap, List<PageLayout__C> pglList){
    System.debug(objMap);
    for (String ids : objMap.keyset()) {
        Pagelayout pgl = getPageLayoutName(objMap.get(ids).developer_Name__c)[0];
        String pgName = pgl.Name;
        String pgId = pgl.pgId;
        for (Profile__C pro : [SELECT Name FROM profile__C]) {
            PageLayout__C pg = new PageLayout__C();
            pg.Name = pgName;
            pg.profile__C = pro.id;
            pg.PageLayoutId__C = pgId;
            pg.object__C = objMap.get(ids).id;

            pglList.add(pg);
        }
        
    }

}
    public List<PageLayout> getPageLayoutName(String objName){
        System.debug(Limits.getCallouts());
        List<PageLayout> layoutLst =  new List<PageLayout>();
        orgAuthentication();
        Integer Offset = 0;
        Boolean flag = true;
        if(!(Schema.getGlobalDescribe().get(objName).getdescribe().isCUstom())){
            try {
                while(flag){
                    string allLayoutsRestUrl = 'https://'+getUrlPrefix()+'.salesforce.com/services/data/v38.0/tooling/query?q=SELECT+Name+%2C+id+FROM+Layout+WHERE+TableEnumOrId=%27' + objName + '%27+LIMIT+1+OFFSET+' + Offset;
                    string urlToRequest = allLayoutsRestUrl ;
                    HttpResponse resp = null;
                    HttpRequest req = new HttpRequest();
                    req.setMethod('GET');
                    req.setEndpoint(urlToRequest);
                    req.setHeader('Authorization', 'Bearer ' + accessToken);
                    
                    Http client = new Http();
                    resp = client.send(req);
                    If((Integer)((Map<String, Object>)JSON.deserializeUntyped(resp.getBody())).get('size') == 1) {
                        List<Object> mapName =(List<object>)((Map<String, Object>)JSON.deserializeUntyped(resp.getBody())).get('records');
                        Map<String, Object> recNme = (Map<String, Object>)mapName[0];
                       
                        PageLayout pg = new PageLayout();
                        pg.Name = (String)recNme.get('Name');
                        pg.pgId = (id)recNme.get('Id');
                        layoutLst.add(pg);
                        Offset++;
                    }else {
                        flag =false;
                        break;
                    }
                }
            } catch (Exception e) {
                System.debug('Exception ==>> ' + e.getMessage() + ' line Number == >> ' + e.getLineNumber());
                ApexPages.addMessage(new apexpages.message(Apexpages.Severity.ERROR, e.getMessage() + 'Line Number ==>> ' + e.getLineNumber()));
            }
        }else {

            string allLayoutsRestUrl = 'https://'+getUrlPrefix()+'.salesforce.com/services/data/v45.0/sobjects/'+objName+'/describe/layouts/';
            HttpResponse resp = null;
            HttpRequest req = new HttpRequest();
            req.setMethod('GET');
            req.setEndpoint(allLayoutsRestUrl);
            
            req.setHeader('Authorization', 'Bearer ' + accessToken);
            Http client = new Http();
            resp = client.send(req);
            Map<String, Object> mapName =((Map<String, Object>)JSON.deserializeUntyped(resp.getBody()));
            List<object> lst =(List<object>) mapName.get('recordTypeMappings');
            
            if (lst.size() > 1) {
                String  layoutId  =' (';
                for(object ob : lst){
                    Map<String, Object> lLst = (Map<String, Object>)(ob);
                    layoutId +=  '\'' + (id)lLst.get('layoutId') + '\', ';
                }

                layoutId = layoutId.substring(0, layoutId.lastindexOf(',')) + ')';
                layoutId = EncodingUtil.urlEncode(layoutId, 'UTF-8');
                flag = false;

                String  allLayoutsRestUrl1 = 'https://'+getUrlPrefix()+'.salesforce.com/services/data/v38.0/tooling/query?q=SELECT+Name+%2C+Id+FROM+Layout+WHERE+Id+IN+' + layoutId;
                HttpResponse  resp1 = new HttpResponse();
                HttpRequest  req1 = new HttpRequest();
                        
                    req1.setMethod('GET');
                    req1.setEndpoint(allLayoutsRestUrl1);
                    req1.setHeader('Authorization', 'Bearer ' + accessToken);
                    
                    Http client1 = new Http();
                    resp1 = client1.send(req1);
                    
                    try {  
                        List<Object> mapName1 =(List<object>)((Map<String, Object>)JSON.deserializeUntyped(resp1.getBody())).get('records');
                        for (Object obj : mapName1){
                            Map<String, Object> recNme = (Map<String, Object>)(obj);
                            PageLayout pg = new PageLayout();
                            pg.Name =(String)recNme.get('Name');
                            pg.pgId = (id)recNme.get('Id');
                            layoutLst.add(pg);
                        }
                    } catch (Exception e) {

                    }
            } else {
                System.debug('else');
                Map<String, List<PageLayout__C>> pgMapForCutomObj = main();
                for(String sKey : pgMapForCutomObj.keyset()){
                    System.debug('#1');
                   if(sKey.toLowerCase() == objName.toLowerCase()){
                       System.debug('#2');
                      for(PageLayOut__C pgl : pgMapForCutomObj.get(sKey)){
                          System.debug('#3');
                            PageLayout pg = new PageLayout();
                            pg.Name = pgl.Name;
                            pg.pgId = pgl.PageLayoutId__C;
                            layoutLst.add(pg);
                      }
                   }
                }
                
            }
            
        }
        return layoutLst;
    }


    public  Map<String, List<PageLayout__C>> main(){
        Map<String, List<PageLayout__C>> pgLayouts = new Map<String, List<PageLayout__C>>();
        String epURL1 = 'https://' + getUrlPrefix() + '.salesforce.com/services/data/v45.0/tooling/query?q=SELECT+Name+FROM+Layout';
        Http h = new HTTP();
        HTTPRequest req = new HTTPRequest();
        req.setMethod('GET');
        req.setHeader('Authorization', 'Bearer ' + accessToken);
        req.setEndpoint(epURL1);
        HTTPResponse res = h.send(req);
        String resbody = res.getBody();
        Map<String, Object> map1 = (Map<String, Object>) JSON.deserializeUntyped(resbody);
        List<Object> list1 = (List<Object>) map1.get('records');

        for(Integer i = list1.size()-1; i > 110; i--){
            
            if(Limits.getCallouts() == 90)
                break;
            String u = (String)((Map<String, Object>)((Map<String, Object>)list1[i]).get('attributes')).get('url');
            Http hI = new HTTP();
            HTTPRequest reqI = new HTTPRequest();
            reqI.setMethod('GET');
            reqI.setHeader('Authorization', 'Bearer ' + accessToken);
            reqI.setEndpoint('https://' + getUrlPrefix() + '.salesforce.com' + u);
            HTTPResponse resI = h.send(reqI);
            String resbodyI = resI.getBody();
            Object obj = (Object) JSON.deserializeUntyped(resbodyI);
            if(obj instanceof List<Object>){
                
            }else{
                Map<String, Object> map1I = (Map<String, Object>) obj;
                String fName = (String) map1I.get('FullName');
                System.debug(fName);
            	initpgLayouts(fName, (String) map1I.get('Id'), pgLayouts);
            }
            
        }
        return pgLayouts;
    }
    
    public  void initpgLayouts(String fName, String ids, Map<String, List<PageLayout__C>> pl){
        String objName = fName.substringBefore('-');
        String pName = fName.substringAfter('-');
        if(pl.containsKey(objName)){
            PageLayout__C pg = new PageLayout__C();
            pg.Name = pName;
            pg.PageLayoutId__C  = ids;
            pl.get(objName).add(pg);
        }else{
            List<PageLayout__C> pN = new List<PageLayout__C>();
            PageLayout__C pg = new PageLayout__C();
            pg.Name = pName;
            pg.PageLayoutId__C  = ids;
            pN.add(pg);
            pl.put(objName, pN);
        }
    }
     
    public void execute(QueueableContext context){  
       pgaelayoutInsertionForbatch();
    } 
    public class PageLayout{
        Public String Name;
        public id pgId ;
    }
    public class ProfRTType{
        public List<ProfileWrapper> profWrapLst {get;set;}
        public List<RecordTypeWrapper> rtWrapLst {get;set;}
    }
    
    public class ProfileWrapper{
        public String profileName {get;set;}
        public Map<String, pageLayoutWrapper> prtLayout {get;set;}
    }

    public class RecordTypeWrapper{
        public String recordTypeName {get;set;}
    }

    public class pageLayoutWrapper{
        public sobject sobj ;
        public Boolean isPermitted {get;set;}
       
    }
  
    
}