package com.distriqt.extension.inappbilling.events
{
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import flash.events.Event;
   
   public class ApplicationReceiptEvent extends Event
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
      
      public static const REFRESH_SUCCESS:String = "applicationreceipt:refresh:success";
      
      public static const REFRESH_FAILED:String = "applicationreceipt:refresh:failed";
      
      public var error:String = "";
      
      public var errorCode:String = "";
      
      public function ApplicationReceiptEvent(param1:String, param2:String = "", param3:String = "", param4:Boolean = false, param5:Boolean = false)
      {
         wlog("com.distriqt.extension.inappbilling.events.ApplicationReceiptEvent.ApplicationReceiptEvent");
         super(param1,param4,param5);
         this.error = param2;
         this.errorCode = param3;
      }
      
      override public function clone() : Event
      {
         return new ApplicationReceiptEvent(type,error,errorCode,bubbles,cancelable);
      }
   }
}

