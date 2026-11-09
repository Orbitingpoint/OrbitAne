package com.distriqt.extension.gameservices.events
{
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import flash.events.Event;
   
   public class TurnBasedMultiplayerEvent extends Event
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
      
      public static const CREATEMATCH_UI_SUCCESS:String = "turnbasedmultiplayer:creatematchui:success";
      
      public static const CREATEMATCH_UI_ERROR:String = "turnbasedmultiplayer:creatematchui:error";
      
      public static const CREATEMATCH_UI_CANCEL:String = "turnbasedmultiplayer:creatematchui:cancel";
      
      public static const LOADMATCHES_SUCCESS:String = "turnbasedmultiplayer:loadmatches:success";
      
      public static const LOADMATCHES_FAILED:String = "turnbasedmultiplayer:loadmatches:failed";
      
      public var data:*;
      
      public function TurnBasedMultiplayerEvent(param1:String, param2:*, param3:Boolean = false, param4:Boolean = false)
      {
         wlog("com.distriqt.extension.gameservices.events.TurnBasedMultiplayerEvent.TurnBasedMultiplayerEvent");
         super(param1,param3,param4);
         this.data = param2;
      }
      
      override public function clone() : Event
      {
         return new TurnBasedMultiplayerEvent(type,data,bubbles,cancelable);
      }
   }
}

