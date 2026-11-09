package com.distriqt.extension.gameservices.achievements
{
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   public class AchievementType
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
      
      public static const TYPE_STANDARD:int = 0;
      
      public static const TYPE_INCREMENTAL:int = 1;
      
      public function AchievementType()
      {
         wlog("com.distriqt.extension.gameservices.achievements.AchievementType.AchievementType");
         super();
      }
   }
}

