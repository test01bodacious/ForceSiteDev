public class abcd {
    
    public static Map<String, List<String>> main(){
        Map<String, List<String>> pgLayouts = new Map<String, List<String>>();
        String accessToken = '00D0b000000R7qN!AQ4AQEXFBJdZES38.pS5dH7PbZGT0WR1nRYDFWfbnpyZNjE54EE4LyaIqplNuEEAnbPRTPclwyKFR1kTsvSy.EQo1DZ4VFi0';
        String epURL1 = 'https://na57.salesforce.com/services/data/v45.0/tooling/query?q=SELECT+Name+FROM+Layout';
        Http h = new HTTP();
        HTTPRequest req = new HTTPRequest();
        req.setMethod('GET');
        req.setHeader('Authorization', 'Bearer ' + accessToken);
        req.setEndpoint(epURL1);
        HTTPResponse res = h.send(req);
        String resbody = res.getBody();
        Map<String, Object> map1 = (Map<String, Object>) JSON.deserializeUntyped(resbody);
        List<Object> list1 = (List<Object>) map1.get('records');
        for(Integer i = list1.size()-1; i > 50; i--){
            String u = (String)((Map<String, Object>)((Map<String, Object>)list1[i]).get('attributes')).get('url');
            Http hI = new HTTP();
            HTTPRequest reqI = new HTTPRequest();
            reqI.setMethod('GET');
            reqI.setHeader('Authorization', 'Bearer ' + accessToken);
            reqI.setEndpoint('https://na57.salesforce.com' + u);
            HTTPResponse resI = h.send(reqI);
            String resbodyI = resI.getBody();
            Object obj = (Object) JSON.deserializeUntyped(resbodyI);
            if(obj instanceof List<Object>){
                
            }else{
                Map<String, Object> map1I = (Map<String, Object>) obj;
                String fName = (String) map1I.get('FullName');
            	initpgLayouts(fName, pgLayouts);
            }
            
        }
        return pgLayouts;
    }
    
    public static void initpgLayouts(String fName, Map<String, List<String>> pl){
        String objName = fName.substringBefore('-');
        String pName = fName.substringAfter('-');
        if(pl.containsKey(objName)){
            pl.get(objName).add(pName);
        }else{
            List<String> pN = new List<String>();
            pN.add(pName);
            pl.put(objName, pN);
        }
    }

}