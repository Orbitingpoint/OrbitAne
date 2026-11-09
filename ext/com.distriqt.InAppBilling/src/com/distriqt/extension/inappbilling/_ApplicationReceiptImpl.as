package com.distriqt.extension.inappbilling
{
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import com.distriqt.extension.inappbilling.events.ApplicationReceiptEvent;
   import flash.events.EventDispatcher;
   import flash.events.StatusEvent;
   import flash.external.ExtensionContext;
   
   internal class _ApplicationReceiptImpl extends EventDispatcher implements ApplicationReceipt
   {

      private static function _safeCallStatic(ctx:*, name:String, ...rest) : *
      {
         try
         {
            if(ctx != null)
            {
               return ctx.call.apply(null,[name].concat(rest));
            }
         }
         catch(e:*) {}
         return null;
      }

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
      
      private var _extContext:ExtensionContext;
      
      public function _ApplicationReceiptImpl(param1:ExtensionContext)
      {
         wlog("com.distriqt.extension.inappbilling._ApplicationReceiptImpl._ApplicationReceiptImpl");
         super();
         _extContext = param1;
         _extContext.addEventListener("status",extContext_statusHandler);
      }
      
      public function dispose() : void
      {
         _extContext.removeEventListener("status",extContext_statusHandler);
         _extContext = null;
      }
      
      public function get isSupported() : Boolean
      {
         try
         {
            return _safeCallStatic(_extContext, "applicationReceipt_isSupported") as Boolean;
         }
         catch(e:Error)
         {
         }
         return false;
      }
      
      public function getAppReceipt() : String
      {
         try
         {
            return _safeCallStatic(_extContext, "applicationReceipt_getAppReceipt") as String;
         }
         catch(e:Error)
         {
         }
         return "";
      }
      
      public function refresh(param1:ApplicationReceiptProperties = null) : Boolean
      {
         try
         {
            if(param1 == null)
            {
               param1 = new ApplicationReceiptProperties();
            }
            return _safeCallStatic(_extContext, "applicationReceipt_refresh",param1) as Boolean;
         }
         catch(e:Error)
         {
         }
         return false;
      }
      
      private function extContext_statusHandler(param1:StatusEvent) : void
      {
         var _loc2_:Object = null;
         switch(param1.code)
         {
            case "applicationreceipt:refresh:success":
               dispatchEvent(new ApplicationReceiptEvent("applicationreceipt:refresh:success"));
               break;
            case "applicationreceipt:refresh:failed":
               _loc2_ = JSON.parse(param1.level);
               dispatchEvent(new ApplicationReceiptEvent("applicationreceipt:refresh:failed",_loc2_.error,_loc2_.errorCode));
         }
      }
   }
}

