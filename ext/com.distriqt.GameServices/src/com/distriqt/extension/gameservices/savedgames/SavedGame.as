package com.distriqt.extension.gameservices.savedgames
{
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import com.distriqt.extension.gameservices.Player;
   import com.distriqt.extension.gameservices.utils.Base64;
   import flash.utils.ByteArray;
   
   public class SavedGame
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
      
      private var _uniqueName:String;
      
      private var _description:String = "";
      
      private var _modified:int;
      
      private var _playedTime:int;
      
      private var _owner:Player;
      
      private var _data:ByteArray;
      
      public function SavedGame()
      {
         wlog("com.distriqt.extension.gameservices.savedgames.SavedGame.SavedGame");
         super();
         _data = new ByteArray();
      }
      
      public static function fromObject(param1:Object) : SavedGame
      {
         var _loc3_:String = null;
         var _loc2_:SavedGame = new SavedGame();
         _loc2_.uniqueName = param1.uniqueName;
         _loc2_.description = param1.description;
         _loc2_.playedTime = param1.playedTime;
         _loc2_.modified = param1.lastModifiedTimestamp;
         _loc2_.owner = Player.fromObject(param1.player);
         if(param1.data)
         {
            _loc3_ = param1.data.replace(/[\s\r\n]+/gim,"");
            _loc2_.data = Base64.decodeToByteArray(_loc3_);
         }
         else
         {
            _loc2_.data = new ByteArray();
         }
         return _loc2_;
      }
      
      public function get uniqueName() : String
      {
         return _uniqueName;
      }
      
      public function set uniqueName(param1:String) : void
      {
         _uniqueName = param1;
      }
      
      public function get description() : String
      {
         return _description;
      }
      
      public function set description(param1:String) : void
      {
         _description = param1;
      }
      
      public function get modified() : int
      {
         return _modified;
      }
      
      public function set modified(param1:int) : void
      {
         _modified = param1;
      }
      
      public function get playedTime() : int
      {
         return _playedTime;
      }
      
      public function set playedTime(param1:int) : void
      {
         _playedTime = param1;
      }
      
      public function get owner() : Player
      {
         return _owner;
      }
      
      public function set owner(param1:Player) : void
      {
         _owner = param1;
      }
      
      public function get data() : ByteArray
      {
         return _data;
      }
      
      public function set data(param1:ByteArray) : void
      {
         _data = param1;
      }
   }
}

