package com.distriqt.extension.inappbilling
{
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   public class ErrorCodes
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
      
      public static const USER_CANCELLED:String = "-1005";
      
      public static const FEATURE_NOT_SUPPORTED:String = "-2";
      
      public static const SERVICE_DISCONNECTED:String = "-1";
      
      public static const RESPONSE_CANCELLED:String = "1";
      
      public static const SERVICE_UNAVAILABLE:String = "2";
      
      public static const BILLING_UNAVAILABLE:String = "3";
      
      public static const ITEM_UNAVAILABLE:String = "4";
      
      public static const DEVELOPER_ERROR:String = "5";
      
      public static const ERROR:String = "6";
      
      public static const ITEM_ALREADY_OWNED:String = "7";
      
      public static const ITEM_NOT_OWNED:String = "8";
      
      public static const ITEM_CONSUMED:String = "9";
      
      public function ErrorCodes()
      {
         wlog("com.distriqt.extension.inappbilling.ErrorCodes.ErrorCodes");
         super();
      }
   }
}

