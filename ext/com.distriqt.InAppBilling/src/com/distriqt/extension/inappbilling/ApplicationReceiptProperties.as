package com.distriqt.extension.inappbilling
{
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   public class ApplicationReceiptProperties
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
      
      public var isExpired:Boolean = false;
      
      public var isRevoked:Boolean = false;
      
      public var isVolumePurchase:Boolean = false;
      
      public function ApplicationReceiptProperties()
      {
         wlog("com.distriqt.extension.inappbilling.ApplicationReceiptProperties.ApplicationReceiptProperties");
         super();
      }
   }
}

