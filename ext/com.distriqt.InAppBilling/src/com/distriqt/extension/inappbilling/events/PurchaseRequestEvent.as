package com.distriqt.extension.inappbilling.events
{
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import com.distriqt.extension.inappbilling.PurchaseRequest;
   import flash.events.Event;
   
   public class PurchaseRequestEvent extends Event
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
      
      private static const TAG:String = "PurchaseRequestEvent";
      
      public static const SHOULD_ADD_PURCHASE:String = "should:add:purchase";
      
      public var request:PurchaseRequest;
      
      public function PurchaseRequestEvent(param1:String, param2:PurchaseRequest, param3:Boolean = false, param4:Boolean = false)
      {
         wlog("com.distriqt.extension.inappbilling.events.PurchaseRequestEvent.PurchaseRequestEvent");
         super(param1,param3,param4);
         this.request = param2;
      }
      
      override public function clone() : Event
      {
         return new PurchaseRequestEvent(type,request,bubbles,cancelable);
      }
   }
}

