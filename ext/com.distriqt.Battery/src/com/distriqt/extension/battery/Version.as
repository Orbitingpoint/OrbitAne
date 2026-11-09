package com.distriqt.extension.battery
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
      
      public static const VERSION:String = "3.0.003";
      
      public function Version()
      {
         wlog("com.distriqt.extension.battery.Version.Version");
         super();
      }
   }
}

