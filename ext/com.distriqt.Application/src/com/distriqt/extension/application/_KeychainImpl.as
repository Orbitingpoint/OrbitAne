package com.distriqt.extension.application
{
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import flash.events.EventDispatcher;
   import flash.external.ExtensionContext;
   
   internal class _KeychainImpl extends EventDispatcher implements Keychain
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
      
      private static const TAG:String = "_KeychainImpl";
      
      private var _extContext:ExtensionContext;
      
      public function _KeychainImpl(param1:ExtensionContext)
      {
         wlog("com.distriqt.extension.application._KeychainImpl._KeychainImpl");
         super();
         _extContext = param1;
      }
      
      public function dispose() : void
      {
      }
      
      public function get isSupported() : Boolean
      {
         try
         {
            return _safeCallStatic(_extContext, "keychain_isSupported") as Boolean;
         }
         catch(e:Error)
         {
         }
         return false;
      }
      
      public function set(param1:String, param2:String, param3:String = null) : int
      {
         try
         {
            return _safeCallStatic(_extContext, "keychain_set",param1,param2,param3) as int;
         }
         catch(e:Error)
         {
         }
         return 0;
      }
      
      public function get(param1:String, param2:String = null) : String
      {
         try
         {
            return _safeCallStatic(_extContext, "keychain_get",param1,param2) as String;
         }
         catch(e:Error)
         {
         }
         return null;
      }
      
      public function remove(param1:String, param2:String = null) : int
      {
         try
         {
            return _safeCallStatic(_extContext, "keychain_remove",param1,param2) as int;
         }
         catch(e:Error)
         {
         }
         return 0;
      }
   }
}

