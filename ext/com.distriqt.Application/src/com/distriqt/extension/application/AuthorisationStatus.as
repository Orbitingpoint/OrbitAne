package com.distriqt.extension.application
{
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   public class AuthorisationStatus
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
      
      public static const AUTHORISED:String = "authorised";
      
      public static const DENIED:String = "denied";
      
      public static const NOT_DETERMINED:String = "not_determined";
      
      public static const RESTRICTED:String = "restricted";
      
      public static const SHOULD_EXPLAIN:String = "should_explain";
      
      public static const UNKNOWN:String = "unknown";
      
      public function AuthorisationStatus()
      {
         wlog("com.distriqt.extension.application.AuthorisationStatus.AuthorisationStatus");
         super();
      }
   }
}

