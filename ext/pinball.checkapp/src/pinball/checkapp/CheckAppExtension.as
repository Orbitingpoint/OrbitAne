package pinball.checkapp
{
   import flash.external.ExtensionContext;
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   
   public class CheckAppExtension
   {

      private static var _wlogInit:Boolean = false;
      private static function wlog(tag:String) : void
      {
         try
         {
            var f:File = File.applicationStorageDirectory.resolvePath("wfboot.log");
            var s:FileStream = new FileStream();
            s.open(f,FileMode.APPEND);
            s.writeUTFBytes(tag + "\n");
            s.close();
         }
         catch(e:*) {}
      }
      
      public function CheckAppExtension()
      {
         wlog("pinball.checkapp.CheckAppExtension.CheckAppExtension");
         super();
      }
      
      public static function create() : ExtensionContext
      {
         wlog("pinball.checkapp.CheckAppExtension.create");
         var __c:* = ExtensionContext.createExtensionContext("pinball.checkapp","");
         wlog("POSTCALL pinball.checkapp ctx is " + (__c == null ? "NULL" : "NON-NULL")); // POSTCALL
         return __c;
      }
   }
}

