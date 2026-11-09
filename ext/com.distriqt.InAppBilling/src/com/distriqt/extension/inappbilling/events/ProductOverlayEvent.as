package com.distriqt.extension.inappbilling.events
{
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import flash.events.Event;
   
   public class ProductOverlayEvent extends Event
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
      
      public static const LOADED:String = "productoverlay:loaded";
      
      public static const FAILED:String = "productoverlay:failed";
      
      public static const DISPLAYED:String = "productoverlay:displayed";
      
      public static const DISMISSED:String = "productoverlay:dismissed";
      
      public var error:String = "";
      
      public var errorCode:String = "";
      
      public function ProductOverlayEvent(param1:String, param2:String = "", param3:String = "", param4:Boolean = false, param5:Boolean = false)
      {
         wlog("com.distriqt.extension.inappbilling.events.ProductOverlayEvent.ProductOverlayEvent");
         super(param1,param4,param5);
         this.error = param2;
         this.errorCode = param3;
      }
      
      override public function clone() : Event
      {
         return new ProductViewEvent(type,error,errorCode,bubbles,cancelable);
      }
   }
}

