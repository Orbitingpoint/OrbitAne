package com.distriqt.extension.application.display
{
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   public class UserInterfaceStyle
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
      
      public static const DARK:String = "dark";
      
      public static const LIGHT:String = "light";
      
      public static const UNSPECIFIED:String = "unspecified";
      
      public function UserInterfaceStyle()
      {
         wlog("com.distriqt.extension.application.display.UserInterfaceStyle.UserInterfaceStyle");
         super();
      }
   }
}

