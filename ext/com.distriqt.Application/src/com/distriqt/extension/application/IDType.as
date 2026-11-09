package com.distriqt.extension.application
{
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   public class IDType
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
      
      [Deprecated("Removed due to possible app rejection by Apple")]
      public static const ADVERTISING:String = "advertising";
      
      public static const VENDOR:String = "vendor";
      
      public static const MAC_ADDRESS:String = "macaddress";
      
      public function IDType()
      {
         wlog("com.distriqt.extension.application.IDType.IDType");
         super();
      }
   }
}

