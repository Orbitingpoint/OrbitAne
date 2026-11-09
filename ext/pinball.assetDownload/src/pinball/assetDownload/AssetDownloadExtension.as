package pinball.assetDownload
{
   import flash.external.ExtensionContext;
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   
   public class AssetDownloadExtension
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
      
      public function AssetDownloadExtension()
      {
         wlog("pinball.assetDownload.AssetDownloadExtension.AssetDownloadExtension");
         super();
      }
      
      public static function create() : ExtensionContext
      {
         wlog("pinball.assetDownload.AssetDownloadExtension.create");
         var __c:* = ExtensionContext.createExtensionContext("pinball.assetDownload","");
         wlog("POSTCALL pinball.assetDownload ctx is " + (__c == null ? "NULL" : "NON-NULL")); // POSTCALL
         return __c;
      }
   }
}

