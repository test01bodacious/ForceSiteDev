public class SiteSingleTonClass {
    private static SiteSingleTonClass instance = null;
    public boolean isTable {get; set;}
    public boolean isGlobalTable {get; set;}
    public boolean isChatter {get; set;}
    public boolean isCreate {get; set;}
    public boolean isHome {get; set;}
    public boolean isLoggedIn {get; set;}
    public boolean isPagination {get; set;}
    private SiteSingleTonClass(){
        isTable = false;
        isGlobalTable = false;
        isChatter = false;
        isCreate = false;
        isHome = false;
        isLoggedIn = false;
        isPagination = false;
    }
    public static SiteSingleTonClass getInstance(){
        if(instance == null)
            instance = new SiteSingleTonClass();
        return instance ;
    }

}