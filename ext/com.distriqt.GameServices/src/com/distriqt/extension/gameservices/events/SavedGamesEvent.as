package com.distriqt.extension.gameservices.events
{
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import flash.events.Event;
   
   public class SavedGamesEvent extends Event
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
      
      public static const LOAD_SUCCESS:String = "savedgames:load:success";
      
      public static const LOAD_ERROR:String = "savedgames:load:error";
      
      public static const UI_SELECT:String = "savedgames:ui:select";
      
      public static const UI_SELECT_NEW:String = "savedgames:ui:new";
      
      public static const UI_CLOSED:String = "savedgames:ui:closed";
      
      public static const CONFLICT:String = "savedgames:conflict";
      
      public static const CONFLICT_RESOLVE_SUCCESS:String = "savedgames:conflict:resolve:success";
      
      public static const CONFLICT_RESOLVE_ERROR:String = "savedgames:conflict:resolve:error";
      
      public static const CREATE_SUCCESS:String = "savedgames:create:success";
      
      public static const CREATE_FAILED:String = "savedgames:create:failed";
      
      public static const CREATE_ERROR:String = "savedgames:create:error";
      
      public static const OPEN_SUCCESS:String = "savedgames:open:success";
      
      public static const OPEN_NOT_FOUND:String = "savedgames:open:notfound";
      
      public static const OPEN_FAILED:String = "savedgames:open:failed";
      
      public static const OPEN_ERROR:String = "savedgames:open:error";
      
      public static const SAVE_SUCCESS:String = "savedgames:save:success";
      
      public static const SAVE_ERROR:String = "savedgames:save:error";
      
      public static const DELETE_SUCCESS:String = "savedgames:delete:success";
      
      public static const DELETE_ERROR:String = "savedgames:delete:error";
      
      public var data:*;
      
      public var conflictId:String = "";
      
      public function SavedGamesEvent(param1:String, param2:* = null, param3:String = "", param4:Boolean = false, param5:Boolean = false)
      {
         wlog("com.distriqt.extension.gameservices.events.SavedGamesEvent.SavedGamesEvent");
         super(param1,param4,param5);
         this.data = param2;
         this.conflictId = param3;
      }
      
      override public function clone() : Event
      {
         return new SavedGamesEvent(type,data,conflictId,bubbles,cancelable);
      }
   }
}

