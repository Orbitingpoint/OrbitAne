package com.distriqt.extension.application.display
{
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   public class LayoutMode
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
      
      public static const CUTOUT_DEFAULT:String = "cutout_default";
      
      public static const CUTOUT_SHORT_EDGES:String = "cutout_short_edges";
      
      public static const CUTOUT_NEVER:String = "cutout_never";
      
      public function LayoutMode()
      {
         wlog("com.distriqt.extension.application.display.LayoutMode.LayoutMode");
         super();
      }
   }
}

