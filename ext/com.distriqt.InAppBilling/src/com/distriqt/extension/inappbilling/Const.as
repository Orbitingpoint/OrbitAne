package com.distriqt.extension.inappbilling
{
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   internal final class Const
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
      
      public static const EXTENSIONID:String = "com.distriqt.InAppBilling";
      
      public static const VERSION:String = "14.0.0";
      
      public function Const()
      {
         wlog("com.distriqt.extension.inappbilling.Const.Const");
         super();
      }
   }
}

