package com.distriqt.extension.gameservices.events
{
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import flash.events.Event;
   
   public class MultiplayerEvent extends Event
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
      
      public static const INVITATION_RECEIVED:String = "multiplayer:invitation:received";
      
      public static const INVITATION_REMOVED:String = "multiplayer:invitation:removed";
      
      public static const LOADINVITES_SUCCESS:String = "multiplayer:loadinvites:success";
      
      public static const LOADINVITES_FAILED:String = "multiplayer:loadinvites:failed";
      
      public static const LOADINVITES_NOT_SUPPORTED:String = "multiplayer:loadinvites:notsupported";
      
      public var data:*;
      
      public var message:String = "";
      
      public function MultiplayerEvent(param1:String, param2:*, param3:String = "", param4:Boolean = false, param5:Boolean = false)
      {
         wlog("com.distriqt.extension.gameservices.events.MultiplayerEvent.MultiplayerEvent");
         super(param1,param4,param5);
         this.data = param2;
         this.message = param3;
      }
      
      override public function clone() : Event
      {
         return new MultiplayerEvent(type,data,message,bubbles,cancelable);
      }
   }
}

