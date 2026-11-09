package com.distriqt.extension.gameservices
{
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   public class ServiceEnvironment
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
      
      public static const PRODUCTION:String = "production";
      
      public static const SANDBOX:String = "sandbox";
      
      public function ServiceEnvironment()
      {
         wlog("com.distriqt.extension.gameservices.ServiceEnvironment.ServiceEnvironment");
         super();
      }
   }
}

