package com.distriqt.extension.inappbilling
{
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import com.distriqt.extension.inappbilling.events.InAppUpdatesEvent;
   import com.distriqt.extension.inappbilling.updates.InAppUpdateInfo;
   import com.distriqt.extension.inappbilling.updates.InAppUpdates;
   import flash.events.EventDispatcher;
   import flash.events.StatusEvent;
   import flash.external.ExtensionContext;
   
   internal class _InAppUpdatesImpl extends EventDispatcher implements InAppUpdates
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
      
      private static const TAG:String = "_InAppUpdatesImpl";
      
      private var _extContext:ExtensionContext;
      
      public function _InAppUpdatesImpl(param1:ExtensionContext)
      {
         wlog("com.distriqt.extension.inappbilling._InAppUpdatesImpl._InAppUpdatesImpl");
         super();
         _extContext = param1;
         _extContext.addEventListener("status",extContext_statusHandler);
      }
      
      public function get isSupported() : Boolean
      {
         try
         {
            return _safeCallStatic(_extContext, "inAppUpdates_isSupported") as Boolean;
         }
         catch(e:Error)
         {
         }
         return false;
      }
      
      public function checkAppUpdate() : Boolean
      {
         try
         {
            return _safeCallStatic(_extContext, "inAppUpdates_checkAppUpdate") as Boolean;
         }
         catch(e:Error)
         {
         }
         return false;
      }
      
      public function startAppUpdate(param1:Boolean = false) : Boolean
      {
         try
         {
            return _safeCallStatic(_extContext, "inAppUpdates_startAppUpdate",param1) as Boolean;
         }
         catch(e:Error)
         {
         }
         return false;
      }
      
      private function extContext_statusHandler(param1:StatusEvent) : void
      {
         var _loc4_:Object = null;
         var _loc3_:int = 0;
         var _loc2_:InAppUpdateInfo = null;
         _loc4_ = null;
         try
         {
            switch(param1.code)
            {
               case "inappupdates:checkAppUpdate:success":
                  _loc4_ = JSON.parse(param1.level);
                  _loc3_ = int(_loc4_.updateAvailability);
                  _loc2_ = null;
                  if(_loc4_.hasOwnProperty("updateInfo"))
                  {
                     _loc2_ = InAppUpdateInfo.fromObject(_loc4_.updateInfo);
                  }
                  dispatchEvent(new InAppUpdatesEvent(param1.code,_loc3_,_loc2_));
                  break;
               case "inappupdates:checkAppUpdate:failed":
                  _loc4_ = JSON.parse(param1.level);
                  dispatchEvent(new InAppUpdatesEvent(param1.code,0,null,_loc4_.errorCode,_loc4_.message));
            }
         }
         catch(e:Error)
         {
         }
      }
   }
}

