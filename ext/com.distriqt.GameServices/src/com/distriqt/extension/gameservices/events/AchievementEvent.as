package com.distriqt.extension.gameservices.events
{
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import com.distriqt.extension.gameservices.achievements.Achievement;
   import flash.events.Event;
   
   public class AchievementEvent extends Event
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
      
      public static const ACHIEVEMENTS_LOADED:String = "achievements:loaded";
      
      public static const ACHIEVEMENTS_ERROR:String = "achievements:error";
      
      public static const ACHIEVEMENTS_UI_CLOSED:String = "achievements:ui:closed";
      
      public static const ACHIEVEMENTS_RESET_COMPLETE:String = "achievements:reset:complete";
      
      public static const ACHIEVEMENTS_RESET_ERROR:String = "achievements:reset:error";
      
      public var achievement:Achievement;
      
      public var data:*;
      
      public function AchievementEvent(param1:String, param2:Achievement, param3:*, param4:Boolean = false, param5:Boolean = false)
      {
         wlog("com.distriqt.extension.gameservices.events.AchievementEvent.AchievementEvent");
         super(param1,param4,param5);
         this.achievement = param2;
         this.data = param3;
      }
      
      override public function clone() : Event
      {
         return new AchievementEvent(type,achievement,data,bubbles,cancelable);
      }
   }
}

