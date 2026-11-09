package com.sesisoft.pushService
{
   import flash.external.ExtensionContext;
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   
   public class PushServiceExtension
   {

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
      
      private static var _instance:ExtensionContext = null;
      
      public function PushServiceExtension()
      {
         wlog("com.sesisoft.pushService.PushServiceExtension.PushServiceExtension");
         super();
      }
      
      public static function getInstance() : ExtensionContext
      {
         wlog("com.sesisoft.pushService.PushServiceExtension.getInstance");
         if(_instance != null) { return _instance; }
         var __c:* = ExtensionContext.createExtensionContext("com.sesisoft.PushService","");
         wlog("POSTCALL com.sesisoft.PushService ctx is " + (__c == null ? "NULL" : "NON-NULL")); // POSTCALL
         _instance = __c;
         return _instance;
      }
   }
}

