package com.distriqt.extension.inappbilling.updates
{
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   public class InAppUpdateAvailablity
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
      
      private static const TAG:String = "InAppUpdateAvailablity";
      
      public static const UPDATE_UNKNOWN:int = 0;
      
      public static const UPDATE_NOT_AVAILABLE:int = 1;
      
      public static const UPDATE_AVAILABLE:int = 2;
      
      public static const DEVELOPER_TRIGGERED_UPDATE_IN_PROGRESS:int = 3;
      
      public function InAppUpdateAvailablity()
      {
         wlog("com.distriqt.extension.inappbilling.updates.InAppUpdateAvailablity.InAppUpdateAvailablity");
         super();
      }
   }
}

