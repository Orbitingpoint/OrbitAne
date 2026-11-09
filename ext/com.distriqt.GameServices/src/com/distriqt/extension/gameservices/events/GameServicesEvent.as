package com.distriqt.extension.gameservices.events
{
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import flash.events.Event;
   
   public class GameServicesEvent extends Event
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
      
      public static const INITIALISED:String = "initialised";
      
      public static const SIGN_IN_SUCCESS:String = "signin:success";
      
      public static const SIGN_IN_FAILED:String = "signin:failed";
      
      public static const SIGN_OUT_SUCCESS:String = "signout:success";
      
      public var message:String = "";
      
      public function GameServicesEvent(param1:String, param2:String = "", param3:Boolean = false, param4:Boolean = false)
      {
         wlog("com.distriqt.extension.gameservices.events.GameServicesEvent.GameServicesEvent");
         super(param1,param3,param4);
         this.message = param2;
      }
      
      override public function clone() : Event
      {
         return new GameServicesEvent(type,message,bubbles,cancelable);
      }
   }
}

