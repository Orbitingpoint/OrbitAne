package com.distriqt.extension.application
{
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   public class IOSStatusBarStyles
   {

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
      
      public static const IOS_STATUS_BAR_DEFAULT:uint = 0;
      
      [Deprecated]
      public static const IOS_STATUS_BLACK_OPAQUE:uint = 1;
      
      [Deprecated]
      public static const IOS_STATUS_BLACK_TRANSLUCENT:uint = 2;
      
      public static const IOS_STATUS_BAR_LIGHT:uint = 3;
      
      public function IOSStatusBarStyles()
      {
         wlog("com.distriqt.extension.application.IOSStatusBarStyles.IOSStatusBarStyles");
         super();
      }
   }
}

