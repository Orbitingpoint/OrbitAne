package com.sesisoft.singularSdk
{
   import flash.external.ExtensionContext;
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   
   public class SingularSdkExtension
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
      
      public function SingularSdkExtension()
      {
         wlog("com.sesisoft.singularSdk.SingularSdkExtension.SingularSdkExtension");
         super();
      }
      
      public static function create() : ExtensionContext
      {
         wlog("com.sesisoft.singularSdk.SingularSdkExtension.create");
         var __c:* = ExtensionContext.createExtensionContext("com.sesisoft.SingularSdk","");
         wlog("POSTCALL com.sesisoft.SingularSdk ctx is " + (__c == null ? "NULL" : "NON-NULL")); // POSTCALL
         return __c;
      }
   }
}

