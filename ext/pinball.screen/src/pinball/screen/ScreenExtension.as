package pinball.screen
{
   import flash.external.ExtensionContext;
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   
   public class ScreenExtension
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
      
      public function ScreenExtension()
      {
         wlog("pinball.screen.ScreenExtension.ScreenExtension");
         super();
      }

      public function createExtensionContext(extensionID:String, contextType:String) : ExtensionContext
      {
         wlog("pinball.screen.ScreenExtension.AS-init " + extensionID + "/" + contextType);
         return null;
      }
      
      public static function create() : ExtensionContext
      {
         wlog("pinball.screen.ScreenExtension.create");
         var __c:* = ExtensionContext.createExtensionContext("pinball.screen","");
         wlog("POSTCALL pinball.screen ctx is " + (__c == null ? "NULL" : "NON-NULL")); // POSTCALL
         return __c;
      }
   }
}

