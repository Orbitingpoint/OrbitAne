package com.distriqt.extension.inappbilling
{
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   public class BillingService
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
      
      private static const TAG:String = "BillingService";
      
      public static const OPERATION_MODE_PRODUCTION:String = "production";
      
      public static const OPERATION_MODE_TEST:String = "test";
      
      public static const OPERATION_MODE_TEST_FAILURE:String = "test_failure";
      
      public var type:String = "default";
      
      public var googlePlayPublicKey:String = "";
      
      public var huaweiAppGalleryPublicKey:String = "";
      
      public var operationMode:String = "production";
      
      public function BillingService(param1:String = "")
      {
         wlog("com.distriqt.extension.inappbilling.BillingService.BillingService");
         super();
         this.type = param1 == "" ? "default" : param1;
      }
      
      public function setServiceType(param1:String) : BillingService
      {
         this.type = param1;
         return this;
      }
      
      public function setGooglePlayPublicKey(param1:String) : BillingService
      {
         this.googlePlayPublicKey = param1;
         return this;
      }
      
      public function setHuaweiIAPPublicKey(param1:String) : BillingService
      {
         this.huaweiAppGalleryPublicKey = param1;
         return this;
      }
      
      public function setOperationMode(param1:String) : BillingService
      {
         this.operationMode = param1;
         return this;
      }
   }
}

