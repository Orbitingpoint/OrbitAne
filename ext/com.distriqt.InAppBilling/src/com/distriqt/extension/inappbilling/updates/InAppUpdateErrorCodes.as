package com.distriqt.extension.inappbilling.updates
{
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   public class InAppUpdateErrorCodes
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
      
      private static const TAG:String = "InAppUpdateErrorCodes";
      
      public static const ERROR_UNKNOWN:int = -1;
      
      public static const ERROR_NONE:int = 0;
      
      public static const ERROR_NO_NETWORK:int = 1;
      
      public static const ERROR_EXCEPTION:int = 2;
      
      public function InAppUpdateErrorCodes()
      {
         wlog("com.distriqt.extension.inappbilling.updates.InAppUpdateErrorCodes.InAppUpdateErrorCodes");
         super();
      }
   }
}

