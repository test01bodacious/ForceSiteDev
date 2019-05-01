public class ListCollectionSite extends Pageable{
    
    public List<sObject> mysObjData;
    public List<TheMainControllerSite.MainRecordWrapperClass> myData{get;set;}
    public String query{get;set;}
    public Integer mainSize{get;set;}
    
    List<Sobject> tst = new List<Sobject>();
    public DateTime dtStart;
    public Datetime dtEnd;
    public Date dat;
    public String field =null;//Phone';
    public String order =null;//'DESC';
    String s= '' ;
    @testvisible boolean flag = false;
    boolean flag1 = true;
    @testvisible  dateTime datfirst;
    @testvisible list<Sobject> obj ;
    @testvisible integer Offsetvalue10 =0;
    @testvisible  List<Sobject> prevObj =  new List<sobject>();
    @testVisible datetime dat20 ;
    @testvisible DateTime dat10;
    @testvisible  List<DateTime> datLst  = new List<DateTime>();
    
    list<sobject> mainlst = new List<sObject>();
    boolean firstcheck = true;
    integer recordint ;
    integer pagenum =1;
    
    public ListCollectionSite(){
        Super.pagesize=10;
      
        myData = new List<TheMainControllerSite.MainRecordWrapperClass>();
    }
    
    public override Integer getRecordCount() {
        super.getRecordCount();
        
        return ((mysObjData.size() == 0 || mysObjData == null)? 0 : mainSize);
    }
   
    public void getmyData(List<sObject> objLst){

        this.myData = new List<TheMainControllerSite.MainRecordWrapperClass>();
        //objlst = sortSobject(objlst, field, order);
        for(sObject s: objLst){
            TheMainControllerSite.MainRecordWrapperClass mnwrap = new TheMainControllerSite.MainRecordWrapperClass(s, false);
            myData.add(mnwrap);
        }
        
    }
    
    
    public override void moveNext(){
        super.moveNext();
    
        if( inc == (this.limitvalue / this.pagesize) -1)
            inc =0 ;
        else
            inc++;
        if(inc ==0 )
        moveFunction(query);
    System.debug(inc);
        
    }
    
    public override void movePrev(){
        
        super.movePrev();
       
        if(inc ==0)
            prevFunction(query);
         if(this.inc == 0)
            inc = (this.limitvalue / this.pagesize) -1;
        else
            inc--;
  
        
    }
    
    public void moveFunction(String pquery){
        
       
       System.debug('in move function!!!!!!!!!!' + offsetvalue10);
        offsetvalue10 += super.limitvalue; 
       
        if(pquery.contains('ORDER'))
            pquery = pquery.substring(0, pquery.lastIndexOf('ORDER'));
        else if(pquery.contains('LIMIT'))
                pquery = pquery.substring(0, pquery.lastIndexOf('LIMIT'));
       //////////////////////////////////////////////////////////////////////// if(pquery.contains('AND'))
            //pquery = pquery.substring(0, pquery.lastIndexOf('AND'));
            //pquery = pquery.substring(0, pquery.lastIndexOf('AND')) ;
        s = pquery;
        

        if(offsetvalue10 > 2000){
            offsetvalue10 -= super.limitvalue; 
            
            if(!(pquery.substring(pquery.IndexOfIgnoreCase('select'), pquery.IndexOfIgnoreCase('from')).containsIgnoreCase('createddate')))
                pquery = 'SELECT createdDate, ' + pquery.substring(6) ;
            
            
            if(datLst.size() >0){
                if(pquery.containsIgnoreCase('WHERE'))
                    pquery += ' AND createdDate > :dat10 ORDER BY createddate ASC LIMIT '+ super.limitvalue + ' OFFSET ' + offsetvalue10;
                else
                    pquery += ' WHERE createdDate > :dat10 ORDER BY createddate ASC LIMIT '+ super.limitvalue + ' OFFSET ' + offsetvalue10;
                try{
                    obj= database.query(pquery);
                }catch(Exception e){
                    ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'There was some problem with the Query'));
                }
                
            }else{
                pquery += ' ORDER BY createddate ASC LIMIT '+ super.limitvalue + ' OFFSET ' + offsetvalue10;
                try{
                    obj= database.query(pquery);
                    dat10 = (DateTime)obj[obj.size()-1].get('createddate');
                }catch(Exception e){
                    ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'There was some problem with the Query'));
                }
            }
            //System.debug(obj.size()-1);
            datLst.add((DateTime)obj[obj.size()-1].get('createddate'));             
            
            dat10 = datLst[datLst.size()-1];
            
            if(firstcheck){
                datfirst = dat10;
                
                firstcheck = false;
            }
            //system.debug(obj[obj.size()-1].get('Name'));
            
            offsetvalue10=0;
            String newStr = s;
            if(s.contains('WHERE'))
                s += '  AND (createddate > :dat10 ) ORDER BY createddate ASC LIMIT ' + super.limitvalue + ' OFFSET ' + offsetvalue10;
            else
                s += '  WHERE (createddate > :dat10 ) ORDER BY createddate ASC LIMIT ' + super.limitvalue + ' OFFSET ' + offsetvalue10;
            try{
                this.mysObjData = database.query(s);
            }catch(Exception e){
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'There was some problem with the Query'));
            }
            getmyData(this.mysObjData);
            
            
            try{
                flag = true;
                if(s.substring(s.IndexOfIgnoreCase('select'), s.IndexOfIgnoreCase('from')).containsIgnoreCase('createddate')){
                    prevObj = database.query(s);
                }else{
                    prevObj = database.query('SELECT createddate, ' + s.substring(6));
                }
                dat20 = (DateTime)(prevObj[prevObj.size()-1].get('createddate'));
            }catch(Exception e){
                Offsetvalue10 = 0;
                s= newstr;
                
                if(this.query.substring(this.query.IndexOfIgnoreCase('select'), this.query.IndexOfIgnoreCase('from')).containsIgnoreCase('createddate')){
                    prevObj = database.query(this.query);
                }else{
                    prevObj = database.query('SELECT createddate, ' + this.query.substring(6));
                }
                dat20 = (DateTime)(prevObj[prevObj.size()-1].get('createddate'));
            }
        }else {if(flag){
            if(s.containsIgnoreCase('WHERE'))
                s += ' AND createddate > :dat10 ORDER BY createddate ASC LIMIT ' + super.limitvalue + ' OFFSET ' + offsetvalue10;
            else
                s += ' WHERE createddate > :dat10 ORDER BY createddate ASC LIMIT ' + super.limitvalue + ' OFFSET ' + offsetvalue10;
        }
               else{
                   
                   s += ' ORDER BY createddate ASC LIMIT '+ super.limitvalue + ' OFFSET ' +offsetvalue10;
               }
          
               try{
                   this.mysObjData = database.query(s);
                   if(s.substring(s.IndexOfIgnoreCase('select'), s.IndexOfIgnoreCase('from')).containsIgnoreCase('createddate')){
						prevObj = database.query(s);
                   }else{
						prevObj = database.query('SELECT createddate, ' + s.substring(6));
                   }
                   
               }catch(exception e){
                   ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'There was some problem with the Query'));
               }
               getmyData(this.mysObjData);
              
            
            
            if(prevObj.size() != null && !prevObj.isEmpty())
                dat20 = (DateTime)(prevObj[prevObj.size()-1].get('createddate'));
               //System.debug(prevObj[prevObj.size()-1].get('Name'));
        }
     
    }
    
    
    public void prevFunction(String pquery){
        
        //system.debug('in prev fun' + offsetvalue10);
        offsetvalue10 -= super.limitvalue;
        
         if(dat20 == datFirst) {
             flag = false;
             offsetvalue10 = 1800;
             firstcheck = true;
                
             datfirst = null;
             dat10 = null;
        
            }
        
        if(flag){
          
            if(dat10 == dat20){
                datLst.remove(datLst.size()-1);
                dat10 = datLst[datLst.size()-1];
                offsetvalue10 = 1800;
              
            }
           
            integer offsetvalue101 = offsetvalue10 + super.limitvalue;
            if(pquery.contains('ORDER'))
                pquery = pquery.substring(0, pquery.lastIndexOf('ORDER'));
            else if(pquery.contains('LIMIT'))
                pquery = pquery.substring(0, pquery.lastIndexOf('LIMIT'));
             
           
            if(pquery.contains('WHERE'))
                pquery += ' AND ( createdDate >= :dat10 ) ORDER BY createddate ASC LIMIT '+ super.limitvalue + ' OFFSET ' +offsetvalue101;
            else
                pquery += ' WHERE ( createdDate >= :dat10 ) ORDER BY createddate ASC LIMIT '+ super.limitvalue + ' OFFSET ' +offsetvalue101;
            try{
                prevObj = database.query('SELECT Createddate, ' + pquery.substring(6));
                dat20 = (DateTime)(prevObj[prevObj.size()-1].get('createddate'));
                this.mysObjData = database.query(pquery);
            }catch(Exception e){
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'There was some problem with the Query'));
            }
           
          
            
            getmyData(this.mysObjData);
            try{
             prevObj = database.query('SELECT Createddate, ' + pquery.substring(6));
            dat20 = (DateTime)(prevObj[prevObj.size()-1].get('createddate'));
            }catch(Exception e) {
                
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'There was some problem with the Query'));
            }
            
        }else{
        
        if(pquery.contains('ORDER'))
            pquery = pquery.substring(0, pquery.lastIndexOf('ORDER'));
        else if(pquery.contains('LIMIT'))
                pquery = pquery.substring(0, pquery.lastIndexOf('LIMIT'));
         pquery += ' ORDER BY createddate ASC LIMIT '+ super.limitvalue + ' OFFSET ' +offsetvalue10;
            try{
            this.mysObjData = database.query(pquery);
             prevObj = database.query('SELECT Createddate, ' + pquery.substring(6));
            dat20 = (DateTime)(prevObj[prevObj.size()-1].get('createddate'));
            }catch(Exception e ){
                   ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'There was some problem with the Query'));
            }
            getmyData(this.mysObjData);
           
             
            
        }
            //system.debug(pquery);
    }
    
    
    public override void moveFirst() {
        
        super.moveFirst();
        this.inc = 0;
        this.offset =0;
        this.offset1 =0;
        if(this.query.contains('ORDER'))
            this.query = this.query.substring(0, this.query.lastIndexOf('ORDER'));
        else if(this.query.contains('LIMIT'))
                this.query = this.query.substring(0, this.query.lastIndexOf('LIMIT'));
        try{
        this.mysObjData = database.query(this.query + 'ORDER BY createddate ASC LIMIT '+ this.limitvalue + 'OFFSET 0');
        }catch(Exception e){
               ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'There was some problem with the Query'));
        }
        getmyData(this.mysObjData);
       
        this.offsetvalue10 =0;
       
    }
    
    
    /*public  List<Sobject> sortSobject(List<Sobject> sobj, String field, String order){
        
     
        Map<sobject, object> mp = new Map<sobject, object>();
        List<Sobject> finalList = new List<sobject>();
        if(field!=null){
            
            for(Sobject a : sobj){
                
                mp.put(a, a.get(field));
            }
            list<Sobject> sobj1 = new List<Sobject>();
            sobj1.addAll(mp.keyset());
            List<object> sval = new List<object>();
            sval.addAll(mp.values());
            sval.sort();
            
            
            List<object> sval1 = new List<object>();
            if(order.equalsIgnoreCase('DESC')){
                
                for(integer i = sval.size()-1 ; i >=0 ; i--)
                    sval1.add(sval[i]);
                sval = sval1;
            }
            for(object a :sval){
                
                for(Sobject s : sobj1){
                   
                    if(a == mp.get(s)){
                        sobj1.remove(sobj1.indexof(s));
                        finalList.add(s);
                        break;
                    }
                }
            }
            return finalList;
        }else
            return sobj;
        
    }*/
    public override void moveLast(){
       
       
       
       this.movefirst();
       pagenumber += (super.limitvalue/super.pagesize);
       
       integer cond =0;
       if(Math.mod(super.recordcount, super.Limitvalue)<=super.pagesize)
       {
           System.debug('In If bloack');
           if(super.recordcount <= 7000)
               cond = Math.round(super.recordcount / super.Limitvalue);
           else
               cond = 35;  
           for(integer i =1 ; i< cond ;i++){
               if(Math.mod(super.recordcount, super.Limitvalue)!=0 && cond-i == 1)
                    movenext();
               else
                   pagenumber += (super.limitvalue/super.pagesize) ;
              
               movefunction(this.query);
               
           }
       
           
         
       }else{
            System.debug('In Else bloack');
           if(super.recordcount <= 7000)
               cond = Math.round(super.recordcount / super.Limitvalue);
           else
               cond = 35;
           if(Math.mod(super.recordcount, super.Limitvalue)!=0)
               cond++;
           
           for(integer i =1 ; i< cond ;i++){
               if(Math.mod(super.recordcount, super.Limitvalue)!=0 && cond-i == 1)
                   super.pagenumber++;
               else
                   pagenumber += (super.limitvalue/super.pagesize) ;
               movefunction(this.query);
               
           }
           //pagenumber++;
           
           integer a =  ((Math.mod(super.recordcount, super.Limitvalue)) / super.pagesize);
           
           for(integer i = 1 ; i <=a  ; i++){
               this.movenext();
               
           }
       }
       this.dat10 = null;
       
       ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.WARNING, 'You can only go for maximum 7000 records. Their may be more records beyond that.'));
       
   } 
   
}