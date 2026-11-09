package com.distriqt.extension.application.keyboard
{
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   public class SoftKeyboardMode
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
      
      public static const ADJUST_RESIZE:String = "adjust_resize";
      
      public static const ADJUST_PAN:String = "adjust_pan";
      
      public static const ADJUST_NONE:String = "adjust_none";
      
      public function SoftKeyboardMode()
      {
         wlog("com.distriqt.extension.application.keyboard.SoftKeyboardMode.SoftKeyboardMode");
         super();
      }
   }
}

