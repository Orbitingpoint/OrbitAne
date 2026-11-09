package com.distriqt.extension.inappbilling.promotions
{
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   public class PromotionVisibility
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
      
      private static const TAG:String = "PromotionVisibility";
      
      public static const DEFAULT:int = 0;
      
      public static const SHOW:int = 1;
      
      public static const HIDE:int = 2;
      
      public function PromotionVisibility()
      {
         wlog("com.distriqt.extension.inappbilling.promotions.PromotionVisibility.PromotionVisibility");
         super();
      }
   }
}

