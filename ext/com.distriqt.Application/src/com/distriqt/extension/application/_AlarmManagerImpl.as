package com.distriqt.extension.application
{
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import com.distriqt.extension.application.alarms.Alarm;
   import com.distriqt.extension.application.alarms.AlarmManager;
   import com.distriqt.extension.application.events.AlarmEvent;
   import flash.events.EventDispatcher;
   import flash.events.StatusEvent;
   import flash.external.ExtensionContext;
   
   internal final class _AlarmManagerImpl extends EventDispatcher implements AlarmManager
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
      
      public function _AlarmManagerImpl(param1:ExtensionContext)
      {
         wlog("com.distriqt.extension.application._AlarmManagerImpl._AlarmManagerImpl");
         super();
         _extContext = param1;
         _extContext.addEventListener("status",extContext_statusHandler);
      }
      
      public function dispose() : void
      {
         if(_extContext)
         {
            _extContext.removeEventListener("status",extContext_statusHandler);
            _extContext = null;
         }
      }
      
      public function get isSupported() : Boolean
      {
         try
         {
            return _safeCallStatic(_extContext, "alarmManager_isSupported") as Boolean;
         }
         catch(e:Error)
         {
         }
         return false;
      }
      
      public function register() : Boolean
      {
         try
         {
            return _safeCallStatic(_extContext, "alarmManager_register") as Boolean;
         }
         catch(e:Error)
         {
         }
         return false;
      }
      
      public function setAlarm(param1:Alarm) : Boolean
      {
         try
         {
            return _safeCallStatic(_extContext, "alarmManager_setAlarm",param1) as Boolean;
         }
         catch(e:Error)
         {
         }
         return false;
      }
      
      public function cancelAlarm(param1:Alarm) : Boolean
      {
         try
         {
            return _safeCallStatic(_extContext, "alarmManager_cancelAlarm",param1) as Boolean;
         }
         catch(e:Error)
         {
         }
         return false;
      }
      
      public function cancelAlarmById(param1:int) : Boolean
      {
         try
         {
            return _safeCallStatic(_extContext, "alarmManager_cancelAlarmById",param1) as Boolean;
         }
         catch(e:Error)
         {
         }
         return false;
      }
      
      public function cancelAllAlarms() : Boolean
      {
         try
         {
            return _safeCallStatic(_extContext, "alarmManager_cancelAllAlarms") as Boolean;
         }
         catch(e:Error)
         {
         }
         return false;
      }
      
      private function extContext_statusHandler(param1:StatusEvent) : void
      {
         var _loc2_:Object = null;
         try
         {
            var _loc4_:String = param1.code;
            if("alarm" === _loc4_)
            {
               _loc2_ = JSON.parse(param1.level);
               dispatchEvent(new AlarmEvent("alarm",_loc2_.id,_loc2_.data));
            }
         }
         catch(e:Error)
         {
         }
      }
   }
}

