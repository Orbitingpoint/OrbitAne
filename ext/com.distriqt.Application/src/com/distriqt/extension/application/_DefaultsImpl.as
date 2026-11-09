package com.distriqt.extension.application
{
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import com.distriqt.extension.application.events.DefaultsEvent;
   import flash.events.EventDispatcher;
   import flash.events.StatusEvent;
   import flash.external.ExtensionContext;
   
   internal class _DefaultsImpl extends EventDispatcher implements Defaults
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
      
      public function _DefaultsImpl(param1:ExtensionContext)
      {
         wlog("com.distriqt.extension.application._DefaultsImpl._DefaultsImpl");
         super();
         _extContext = param1;
         _extContext.addEventListener("status",extension_statusHandler);
      }
      
      public function dispose() : void
      {
         if(_extContext)
         {
            _extContext.removeEventListener("status",extension_statusHandler);
            _extContext = null;
         }
      }
      
      public function save() : Boolean
      {
         return _safeCallStatic(_extContext, "defaults_save") as Boolean;
      }
      
      public function remove(param1:String) : void
      {
         _safeCallStatic(_extContext, "defaults_remove",param1);
      }
      
      public function setBoolean(param1:String, param2:Boolean) : Boolean
      {
         return _safeCallStatic(_extContext, "defaults_setBoolean",param1,param2) as Boolean;
      }
      
      public function getBoolean(param1:String) : Boolean
      {
         return _safeCallStatic(_extContext, "defaults_getBoolean",param1) as Boolean;
      }
      
      public function setString(param1:String, param2:String) : Boolean
      {
         return _safeCallStatic(_extContext, "defaults_setString",param1,param2) as Boolean;
      }
      
      public function getString(param1:String) : String
      {
         return _safeCallStatic(_extContext, "defaults_getString",param1) as String;
      }
      
      public function setNumber(param1:String, param2:Number) : Boolean
      {
         return _safeCallStatic(_extContext, "defaults_setNumber",param1,param2) as Boolean;
      }
      
      public function getNumber(param1:String) : Number
      {
         return _safeCallStatic(_extContext, "defaults_getNumber",param1) as Number;
      }
      
      public function setInt(param1:String, param2:int) : Boolean
      {
         return _safeCallStatic(_extContext, "defaults_setInt",param1,param2) as Boolean;
      }
      
      public function getInt(param1:String) : int
      {
         return _safeCallStatic(_extContext, "defaults_getInt",param1) as int;
      }
      
      public function setObject(param1:String, param2:Object) : Boolean
      {
         try
         {
            return _safeCallStatic(_extContext, "defaults_setObject",param1,JSON.stringify(param2)) as Boolean;
         }
         catch(e:Error)
         {
         }
         return false;
      }
      
      public function getObject(param1:String) : Object
      {
         var _loc2_:String = null;
         try
         {
            _loc2_ = _safeCallStatic(_extContext, "defaults_getObject",param1) as String;
            return JSON.parse(_loc2_);
         }
         catch(e:Error)
         {
         }
         return null;
      }
      
      private function extension_statusHandler(param1:StatusEvent) : void
      {
         var _loc2_:Object = null;
         try
         {
            var _loc4_:String = param1.code;
            if("defaults:changed" === _loc4_)
            {
               _loc2_ = JSON.parse(param1.level);
               dispatchEvent(new DefaultsEvent("defaults:changed",_loc2_.key));
            }
         }
         catch(e:Error)
         {
         }
      }
   }
}

