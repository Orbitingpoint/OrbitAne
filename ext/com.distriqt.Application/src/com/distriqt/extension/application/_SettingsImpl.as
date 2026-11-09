package com.distriqt.extension.application
{
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import com.distriqt.extension.application.events.SettingsEvent;
   import flash.events.EventDispatcher;
   import flash.events.StatusEvent;
   import flash.external.ExtensionContext;
   
   internal class _SettingsImpl extends EventDispatcher implements Settings
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
      
      private static const TAG:String = "_SettingsImpl";
      
      private var _extContext:ExtensionContext;
      
      public function _SettingsImpl(param1:ExtensionContext)
      {
         wlog("com.distriqt.extension.application._SettingsImpl._SettingsImpl");
         super();
         _extContext = param1;
         _extContext.addEventListener("status",extension_statusHandler);
      }
      
      public function dispose() : void
      {
         if(_extContext != null)
         {
            _extContext.removeEventListener("status",extension_statusHandler);
            _extContext = null;
         }
      }
      
      public function get isSupported() : Boolean
      {
         try
         {
            return _safeCallStatic(_extContext, "settings_isSupported");
         }
         catch(e:Error)
         {
         }
         return false;
      }
      
      public function openSettingsScreen() : Boolean
      {
         try
         {
            return _safeCallStatic(_extContext, "settings_openSettingsScreen");
         }
         catch(e:Error)
         {
         }
         return false;
      }
      
      public function setBoolean(param1:String, param2:Boolean) : Boolean
      {
         return _safeCallStatic(_extContext, "settings_setBoolean",param1,param2) as Boolean;
      }
      
      public function getBoolean(param1:String) : Boolean
      {
         return _safeCallStatic(_extContext, "settings_getBoolean",param1) as Boolean;
      }
      
      public function setString(param1:String, param2:String) : Boolean
      {
         return _safeCallStatic(_extContext, "settings_setString",param1,param2) as Boolean;
      }
      
      public function getString(param1:String) : String
      {
         return _safeCallStatic(_extContext, "settings_getString",param1) as String;
      }
      
      public function setNumber(param1:String, param2:Number) : Boolean
      {
         return _safeCallStatic(_extContext, "settings_setNumber",param1,param2) as Boolean;
      }
      
      public function getNumber(param1:String) : Number
      {
         return _safeCallStatic(_extContext, "settings_getNumber",param1) as Number;
      }
      
      public function setInt(param1:String, param2:int) : Boolean
      {
         return _safeCallStatic(_extContext, "settings_setInt",param1,param2) as Boolean;
      }
      
      public function getInt(param1:String) : int
      {
         return _safeCallStatic(_extContext, "settings_getInt",param1) as int;
      }
      
      private function extension_statusHandler(param1:StatusEvent) : void
      {
         var _loc2_:Object = null;
         try
         {
            var _loc4_:String = param1.code;
            if("settings:changed" === _loc4_)
            {
               _loc2_ = JSON.parse(param1.level);
               dispatchEvent(new SettingsEvent("settings:changed",_loc2_.key));
            }
         }
         catch(e:Error)
         {
         }
      }
   }
}

