package com.distriqt.extension.application.display
{
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   public class AndroidSystemUiFlags
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
      
      public static const SYSTEM_UI_FLAG_VISIBLE:int = 0;
      
      public static const SYSTEM_UI_FLAG_LOW_PROFILE:int = 1;
      
      public static const SYSTEM_UI_FLAG_HIDE_NAVIGATION:int = 2;
      
      public static const SYSTEM_UI_FLAG_FULLSCREEN:int = 4;
      
      public static const SYSTEM_UI_FLAG_LIGHT_NAVIGATION_BAR:int = 16;
      
      public static const SYSTEM_UI_FLAG_LAYOUT_STABLE:int = 256;
      
      public static const SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION:int = 512;
      
      public static const SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN:int = 1024;
      
      public static const SYSTEM_UI_FLAG_IMMERSIVE:int = 2048;
      
      public static const SYSTEM_UI_FLAG_IMMERSIVE_STICKY:int = 4096;
      
      public static const SYSTEM_UI_FLAG_LIGHT_STATUS_BAR:int = 8192;
      
      public function AndroidSystemUiFlags()
      {
         wlog("com.distriqt.extension.application.display.AndroidSystemUiFlags.AndroidSystemUiFlags");
         super();
      }
   }
}

