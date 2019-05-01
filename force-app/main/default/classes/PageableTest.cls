@isTest
private class PageableTest {
    
    @isTest
    static void variableTest(){
        Pageable p = new Pageable();
      
        p.PageSize = 10;
       
        
        System.assertEquals(0, p.PageIndex);
        System.assertEquals(0, p.RecordCount);
        System.assertEquals(1, p.PageCount);
        System.assertEquals(0, p.Offset);
        System.assertEquals(0, p.LNumber);
        System.assertEquals(0, p.UNumber);
        System.assertEquals(false, p.AllowMoveNext);
        System.assertEquals(false, p.AllowMovePrev);
        
    }
    
    @isTest
    static void moveTest(){
        Pageable p = new Pageable();
       
        p.PageSize = 10;
        p.movePrev();
        p.moveNext();
        p.moveLast();
        p.moveFirst();    
    }
    
}