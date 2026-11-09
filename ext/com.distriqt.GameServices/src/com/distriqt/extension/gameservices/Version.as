package com.distriqt.extension.gameservices
{
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   internal final class Version
   {

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
      
      public static const VERSION:String = "5.0.005";
      
      public function Version()
      {
         wlog("com.distriqt.extension.gameservices.Version.Version");
         super();
      }
   }
}

