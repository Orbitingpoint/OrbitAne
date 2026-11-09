package com.distriqt.extension.core
{
   import flash.desktop.NativeApplication;
   import flash.events.ErrorEvent;
   import flash.events.EventDispatcher;
   import flash.events.InvokeEvent;
   import flash.events.StatusEvent;
   import flash.external.ExtensionContext;
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   
   public final class Core extends EventDispatcher
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

      private static var _wlogInit:Boolean = false;
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
      
      public static const EXT_CONTEXT_ID:String = "com.distriqt.Core";
      
      public static const VERSION:String = "4.0.269";
      
      private static const VERSION_DEFAULT:String = "0";
      
      private static const IMPLEMENTATION_DEFAULT:String = "unknown";
      
      private static const ERROR_CREATION:String = "The native extension context could not be created";
      
      private static const ERROR_SINGLETON:String = "The singleton has already been created. Use Core.service to access the functionality";
      
      private static var _extContext:ExtensionContext = null;
      
      private static var _instance:Core;
      
      private static var _shouldCreateInstance:Boolean = false;
      
      private var _extensionId:String = "";
      
      public function Core()
      {
         wlog("com.distriqt.extension.core.Core.Core");
         super();
         if(_shouldCreateInstance)
         {
            try
            {
               _extensionId = "com.distriqt.Core";
               _extContext = ExtensionContext.createExtensionContext("com.distriqt.Core",null);
               _extContext.addEventListener("status",extension_statusHandler,false,0,true);
            }
            catch(e:Error)
            {
               /* stub: no native context on Windows */
            }
            return;
         }
         throw new Error("The singleton has already been created. Use Core.service to access the functionality");
      }
      
      public static function get service() : Core
      {
         createInstance();
         return _instance;
      }
      
      private static function createInstance() : void
      {
         if(_instance == null)
         {
            _shouldCreateInstance = true;
            _instance = new Core();
            _shouldCreateInstance = false;
         }
      }
      
      public static function init(param1:String = "") : void
      {
         wlog("com.distriqt.extension.core.Core.init");
         createInstance();
      }
      
      public static function get isSupported() : Boolean
      {
         createInstance();
         return _safeCallStatic(_extContext, "isSupported");
      }
      
      public function dispose() : void
      {
         if(_extContext)
         {
            _extContext.removeEventListener("status",extension_statusHandler);
            _extContext.dispose();
            _extContext = null;
         }
         _instance = null;
      }
      
      public function get version() : String
      {
         return "4.0.269";
      }
      
      public function get nativeVersion() : String
      {
         try
         {
            return _safeCallStatic(_extContext, "version") as String;
         }
         catch(e:Error)
         {
         }
         return "0";
      }
      
      public function get implementation() : String
      {
         try
         {
            return _safeCallStatic(_extContext, "implementation") as String;
         }
         catch(e:Error)
         {
         }
         return "unknown";
      }
      
      private function getReason(param1:String) : String
      {
         switch(param1)
         {
            case "launch":
               return "standard";
            case "notification":
               return "notification";
            case "openUrl":
               return "openUrl";
            case "login":
               return "login";
            default:
               return "standard";
         }
      }
      
      private function extension_statusHandler(param1:StatusEvent) : void
      {
         var _loc4_:Object = null;
         var _loc5_:String = null;
         var _loc3_:String = null;
         var _loc2_:Array = null;
         switch(param1.code)
         {
            case "extension:error":
               dispatchEvent(new ErrorEvent("error",false,false,param1.level));
               break;
            case "invoke":
               try
               {
                  _loc4_ = JSON.parse(param1.level);
                  _loc5_ = "invoke";
                  _loc3_ = getReason(_loc4_.reason);
                  _loc2_ = _loc4_.args;
                  NativeApplication.nativeApplication.dispatchEvent(new InvokeEvent(_loc5_,false,false,null,_loc2_,_loc3_));
               }
               catch(e:Error)
               {
                  trace(e);
               }
         }
      }
   }
}

