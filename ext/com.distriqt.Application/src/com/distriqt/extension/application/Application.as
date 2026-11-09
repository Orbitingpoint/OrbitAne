package com.distriqt.extension.application
{
   import com.distriqt.extension.application.alarms.AlarmManager;
   import com.distriqt.extension.application.display.Display;
   import com.distriqt.extension.application.events.ApplicationEvent;
   import com.distriqt.extension.application.events.ApplicationStateEvent;
   import com.distriqt.extension.application.events.AuthorisationEvent;
   import com.distriqt.extension.application.keyboard.SoftKeyboard;
   import flash.display.BitmapData;
   import flash.display.Stage;
   import flash.events.ErrorEvent;
   import flash.events.EventDispatcher;
   import flash.events.StatusEvent;
   import flash.external.ExtensionContext;
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   
   public class Application extends EventDispatcher
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
      
      public static const EXT_CONTEXT_ID:String = "com.distriqt.Application";
      
      private static const EXT_ID_NUMBER:int = 20;
      
      public static const VERSION:String = "6.5.049";
      
      private static const VERSION_DEFAULT:String = "0";
      
      private static const IMPLEMENTATION_DEFAULT:String = "unknown";
      
      public static const ERROR_CREATION:String = "The native extension context could not be created";
      
      public static const ERROR_SINGLETON:String = "The singleton has already been created. Use [ExtensionClass].instance to access the functionality";
      
      private static var _instance:Application;
      
      private static var _shouldCreateInstance:Boolean = false;
      
      private static var _extContext:ExtensionContext = null;
      
      private var _extensionId:String = "";
      
      private var _extensionIdNumber:int = -1;
      
      private var _stage:Stage = null;
      
      private var _device:Device;
      
      private var _defaults:Defaults;
      
      private var _keychain:Keychain;
      
      private var _settings:Settings;
      
      private var _alarmManager:AlarmManager;
      
      private var _keyboard:SoftKeyboard;
      
      private var _display:Display;
      
      private var _accessibility:Accessibility;
      
      public function Application()
      {
         wlog("com.distriqt.extension.application.Application.Application");
         super();
         if(_shouldCreateInstance)
         {
            try
            {
               _extensionId = "com.distriqt.Application";
               _extensionIdNumber = 20;
               _extContext = ExtensionContext.createExtensionContext("com.distriqt.Application",null);
               _extContext.addEventListener("status",extension_statusHandler);
            }
            catch(e:Error)
            {
               /* stub: no native context on Windows */
            }
            return;
         }
         throw new Error("The singleton has already been created. Use [ExtensionClass].instance to access the functionality");
      }
      
      public static function get service() : Application
      {
         createInstance();
         return _instance;
      }
      
      private static function createInstance() : void
      {
         if(_instance == null)
         {
            _shouldCreateInstance = true;
            _instance = new Application();
            _shouldCreateInstance = false;
         }
      }
      
      [Deprecated(message="You no longer need to use an application key")]
      public static function init(param1:String = "") : void
      {
         wlog("com.distriqt.extension.application.Application.init");
         createInstance();
      }
      
      public static function get isSupported() : Boolean
      {
         createInstance();
         return _safeCallStatic(_extContext, "isSupported");
      }
      
      public function get version() : String
      {
         return "6.5.049";
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
      
      public function dispose() : void
      {
         if(_device)
         {
            _DeviceImpl(_device).dispose();
            _device = null;
         }
         if(_defaults)
         {
            _DefaultsImpl(_defaults).dispose();
            _defaults = null;
         }
         if(_keychain)
         {
            _KeychainImpl(_keychain).dispose();
            _keychain = null;
         }
         if(_settings)
         {
            _SettingsImpl(_settings).dispose();
            _settings = null;
         }
         if(_alarmManager)
         {
            _AlarmManagerImpl(_alarmManager).dispose();
            _alarmManager = null;
         }
         if(_keyboard)
         {
            _SoftKeyboardImpl(_keyboard).dispose();
            _keyboard = null;
         }
         if(_display)
         {
            _DisplayImpl(_display).dispose();
            _display = null;
         }
         if(_extContext)
         {
            _extContext.removeEventListener("status",extension_statusHandler);
            _extContext.dispose();
            _extContext = null;
         }
         _instance = null;
      }
      
      public function setStage(param1:Stage) : void
      {
         _stage = param1;
         if(_display)
         {
            _DisplayImpl(_display).setStage(_stage);
         }
         if(_keyboard)
         {
            _SoftKeyboardImpl(_keyboard).setStage(_stage);
         }
      }
      
      public function authorisationStatus() : String
      {
         try
         {
            return _safeCallStatic(_extContext, "authorisationStatus") as String;
         }
         catch(e:Error)
         {
         }
         return "unknown";
      }
      
      public function hasAccess() : Boolean
      {
         try
         {
            return _safeCallStatic(_extContext, "hasAccess") as Boolean;
         }
         catch(e:Error)
         {
         }
         return false;
      }
      
      public function requestAccess() : Boolean
      {
         try
         {
            return _safeCallStatic(_extContext, "requestAccess") as Boolean;
         }
         catch(e:Error)
         {
         }
         return false;
      }
      
      public function setAutoStart(param1:Boolean) : Boolean
      {
         try
         {
            return _safeCallStatic(_extContext, "setAutoStart",param1) as Boolean;
         }
         catch(e:Error)
         {
         }
         return false;
      }
      
      public function isAutoStartEnabled() : Boolean
      {
         try
         {
            return _safeCallStatic(_extContext, "isAutoStartEnabled") as Boolean;
         }
         catch(e:Error)
         {
         }
         return false;
      }
      
      public function wasAutoStarted() : Boolean
      {
         try
         {
            return _safeCallStatic(_extContext, "wasAutoStarted") as Boolean;
         }
         catch(e:Error)
         {
         }
         return false;
      }
      
      [Deprecated(message="See Display.setDisplayMode")]
      public function setDisplayMode(param1:String) : void
      {
         display.setDisplayMode(ApplicationDisplayModes.toDisplayMode(param1));
      }
      
      public function checkUrlSchemeSupport(param1:String) : Boolean
      {
         try
         {
            return _safeCallStatic(_extContext, "checkUrlSchemeSupport",param1);
         }
         catch(e:Error)
         {
            trace(e.message);
         }
         return false;
      }
      
      [Deprecated(replacement="Display#setStatusBarStyle")]
      public function setStatusBarStyle(param1:uint, param2:Boolean = false) : Boolean
      {
         return display.setStatusBarStyle(param1,param2);
      }
      
      [Deprecated(replacement="Display#setStatusBarHidden")]
      public function setStatusBarHidden(param1:Boolean = true, param2:String = "none") : Boolean
      {
         return display.setStatusBarHidden(param1,param2);
      }
      
      [Deprecated(replacement="Display#setStatusBarColour")]
      public function setStatusBarColour(param1:uint, param2:Number = 1) : Boolean
      {
         return display.setStatusBarColour(param1,param2);
      }
      
      [Deprecated(replacement="Display#getStatusBarHeight")]
      public function getStatusBarHeight() : int
      {
         return display.getStatusBarHeight();
      }
      
      public function setRequestedOrientation(param1:String) : Boolean
      {
         try
         {
            return _safeCallStatic(_extContext, "setRequestedOrientation",param1) as Boolean;
         }
         catch(e:Error)
         {
         }
         return false;
      }
      
      public function get device() : Device
      {
         if(_device == null)
         {
            _device = new _DeviceImpl(_extContext);
         }
         return _device;
      }
      
      public function get defaults() : Defaults
      {
         if(_defaults == null)
         {
            _defaults = new _DefaultsImpl(_extContext);
         }
         return _defaults;
      }
      
      public function get keychain() : Keychain
      {
         if(_keychain == null)
         {
            _keychain = new _KeychainImpl(_extContext);
         }
         return _keychain;
      }
      
      public function get settings() : Settings
      {
         if(_settings == null)
         {
            _settings = new _SettingsImpl(_extContext);
         }
         return _settings;
      }
      
      public function get alarmManager() : AlarmManager
      {
         if(_alarmManager == null)
         {
            _alarmManager = new _AlarmManagerImpl(_extContext);
         }
         return _alarmManager;
      }
      
      public function get keyboard() : SoftKeyboard
      {
         if(_keyboard == null)
         {
            _keyboard = new _SoftKeyboardImpl(_extContext,_stage);
         }
         return _keyboard;
      }
      
      public function get display() : Display
      {
         if(_display == null)
         {
            _display = new _DisplayImpl(_extContext,_stage);
         }
         return _display;
      }
      
      public function blackScreenHelper() : void
      {
         try
         {
            _safeCallStatic(_extContext, "blackScreenHelper");
         }
         catch(e:Error)
         {
         }
      }
      
      public function backButtonHelper() : void
      {
         try
         {
            _safeCallStatic(_extContext, "backButtonHelper");
         }
         catch(e:Error)
         {
         }
      }
      
      public function addBitmapOverlay(param1:BitmapData) : void
      {
         try
         {
            _safeCallStatic(_extContext, "addBitmapOverlay",param1);
         }
         catch(e:Error)
         {
         }
      }
      
      public function removeBitmapOverlay() : void
      {
         try
         {
            _safeCallStatic(_extContext, "removeBitmapOverlay");
         }
         catch(e:Error)
         {
         }
      }
      
      public function get accessibility() : Accessibility
      {
         if(_accessibility == null)
         {
            _accessibility = new _Accessibility(_extContext);
         }
         return _accessibility;
      }
      
      override public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         super.addEventListener(param1,param2,param3,param4,param5);
         try
         {
            switch(param1)
            {
               case "applicationstate:activate":
               case "applicationstate:foreground":
               case "applicationstate:background":
               case "applicationstate:deactivate":
                  _safeCallStatic(_extContext, "addEventListener",param1);
            }
         }
         catch(e:Error)
         {
         }
      }
      
      override public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         super.removeEventListener(param1,param2,param3);
         try
         {
            switch(param1)
            {
               case "applicationstate:foreground":
               case "applicationstate:background":
               case "applicationstate:activate":
               case "applicationstate:deactivate":
                  _safeCallStatic(_extContext, "removeEventListener",param1);
            }
         }
         catch(e:Error)
         {
         }
      }
      
      private function extension_statusHandler(param1:StatusEvent) : void
      {
         var _loc2_:Object = null;
         switch(param1.code)
         {
            case "extension:error":
               dispatchEvent(new ErrorEvent("error",false,false,param1.level));
               break;
            case "authorisation:changed":
               try
               {
                  _loc2_ = JSON.parse(param1.level);
                  dispatchEvent(new AuthorisationEvent("authorisation:changed",_loc2_.status));
               }
               catch(e:Error)
               {
               }
               break;
            case "ui:navigation:changed":
               dispatchEvent(new ApplicationEvent("ui:navigation:changed",param1.level));
               break;
            case "applicationstate:foreground":
            case "applicationstate:background":
            case "applicationstate:activate":
            case "applicationstate:deactivate":
               try
               {
                  _loc2_ = JSON.parse(param1.level);
                  dispatchEvent(new ApplicationStateEvent(param1.code,_loc2_.code,_loc2_.description));
               }
               catch(e:Error)
               {
               }
               break;
            case "exception":
         }
      }
   }
}

