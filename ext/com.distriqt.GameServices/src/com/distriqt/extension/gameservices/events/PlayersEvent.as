package com.distriqt.extension.gameservices.events
{
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import flash.events.Event;
   
   public class PlayersEvent extends Event
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
      
      public static const LOAD_PLAYER_FRIENDS_SUCCESS:String = "players:loadPlayerFriends:success";
      
      public static const LOAD_PLAYER_FRIENDS_ERROR:String = "players:loadPlayerFriends:error";
      
      public var players:Array;
      
      public var message:String;
      
      public var code:int;
      
      public function PlayersEvent(param1:String, param2:Array, param3:String = "", param4:int = -1, param5:Boolean = false, param6:Boolean = false)
      {
         wlog("com.distriqt.extension.gameservices.events.PlayersEvent.PlayersEvent");
         super(param1,param5,param6);
         this.players = param2;
         this.message = param3;
         this.code = param4;
      }
      
      override public function clone() : Event
      {
         return new PlayersEvent(type,players,message,code,bubbles,cancelable);
      }
   }
}

