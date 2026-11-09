package com.sesisoft.gxshield
{
   import flash.external.ExtensionContext;
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   
   public class GxShieldExtension
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
      
      public function GxShieldExtension()
      {
         wlog("com.sesisoft.gxshield.GxShieldExtension.GxShieldExtension");
         super();
      }
      
      public static function getInstance() : ExtensionContext
      {
         wlog("com.sesisoft.gxshield.GxShieldExtension.getInstance");
         if(_instance != null) { return _instance; }
         var __c:* = ExtensionContext.createExtensionContext("com.sesisoft.gxshield","");
         wlog("POSTCALL com.sesisoft.gxshield ctx is " + (__c == null ? "NULL" : "NON-NULL")); // POSTCALL
         _instance = __c;
         return _instance;
      }
   }
}

