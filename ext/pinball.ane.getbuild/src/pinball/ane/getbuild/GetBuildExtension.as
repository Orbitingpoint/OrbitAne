package pinball.ane.getbuild
{
   import flash.external.ExtensionContext;
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   
   public class GetBuildExtension
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
      
      public function GetBuildExtension()
      {
         wlog("pinball.ane.getbuild.GetBuildExtension.GetBuildExtension");
         super();
      }
      
      public static function create() : ExtensionContext
      {
         wlog("pinball.ane.getbuild.GetBuildExtension.create");
         var __c:* = ExtensionContext.createExtensionContext("pinball.ane.getbuild","");
         wlog("POSTCALL pinball.ane.getbuild ctx is " + (__c == null ? "NULL" : "NON-NULL")); // POSTCALL
         return __c;
      }
   }
}

