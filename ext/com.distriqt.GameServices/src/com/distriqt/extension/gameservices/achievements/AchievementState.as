package com.distriqt.extension.gameservices.achievements
{
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   public class AchievementState
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
      
      public static const STATE_UNLOCKED:int = 0;
      
      public static const STATE_REVEALED:int = 1;
      
      public static const STATE_HIDDEN:int = 2;
      
      public function AchievementState()
      {
         wlog("com.distriqt.extension.gameservices.achievements.AchievementState.AchievementState");
         super();
      }
   }
}

