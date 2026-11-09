package com.distriqt.extension.inappbilling
{
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   public final class InAppBillingServiceTypes
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
      
      public static const DEFAULT:String = "default";
      
      public static const APPLE_INAPP_PURCHASE:String = "apple_inapp_purchase";
      
      public static const GOOGLE_PLAY_INAPP_BILLING:String = "google_play_inapp_billing";
      
      public static const AMAZON_INAPP_PURCHASING:String = "amazon_inapp_purchasing";
      
      public static const HUAWEI_APP_GALLERY:String = "huawei_app_gallery";
      
      public static const SAMSUNG_INAPP_PURCHASE:String = "samsung_inapp_purchase";
      
      public function InAppBillingServiceTypes()
      {
         wlog("com.distriqt.extension.inappbilling.InAppBillingServiceTypes.InAppBillingServiceTypes");
         super();
      }
   }
}

