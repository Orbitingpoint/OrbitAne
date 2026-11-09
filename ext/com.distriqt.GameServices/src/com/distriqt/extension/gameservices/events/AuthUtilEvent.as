package com.distriqt.extension.gameservices.events
{
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import flash.events.Event;
   
   public class AuthUtilEvent extends Event
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
      
      public static const AUTH_TOKEN_SUCCESS:String = "auth:token:success";
      
      public static const AUTH_TOKEN_ERROR:String = "auth:token:error";
      
      public var data:Object;
      
      public function AuthUtilEvent(param1:String, param2:Object, param3:Boolean = false, param4:Boolean = false)
      {
         wlog("com.distriqt.extension.gameservices.events.AuthUtilEvent.AuthUtilEvent");
         super(param1,param3,param4);
         this.data = param2;
      }
      
      override public function clone() : Event
      {
         return new AuthUtilEvent(type,data,bubbles,cancelable);
      }
   }
}

