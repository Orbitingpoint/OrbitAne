package com.distriqt.extension.gameservices.leaderboards
{
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import com.distriqt.extension.gameservices.Player;
   
   public class LeaderboardScore
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
      
      private var _player:Player;
      
      private var _displayRank:String;
      
      private var _displayScore:String;
      
      private var _rank:Number;
      
      private var _rawScore:Number;
      
      public function LeaderboardScore()
      {
         wlog("com.distriqt.extension.gameservices.leaderboards.LeaderboardScore.LeaderboardScore");
         super();
      }
      
      public static function fromObject(param1:Object) : LeaderboardScore
      {
         var _loc2_:LeaderboardScore = new LeaderboardScore();
         _loc2_.player = Player.fromObject(param1.player);
         _loc2_.displayRank = param1.displayRank;
         _loc2_.displayScore = param1.displayScore;
         _loc2_.rank = param1.rank;
         _loc2_.rawScore = param1.rawScore;
         return _loc2_;
      }
      
      public function get player() : Player
      {
         return _player;
      }
      
      public function set player(param1:Player) : void
      {
         _player = param1;
      }
      
      public function get displayRank() : String
      {
         return _displayRank;
      }
      
      public function set displayRank(param1:String) : void
      {
         _displayRank = param1;
      }
      
      public function get displayScore() : String
      {
         return _displayScore;
      }
      
      public function set displayScore(param1:String) : void
      {
         _displayScore = param1;
      }
      
      public function get rank() : Number
      {
         return _rank;
      }
      
      public function set rank(param1:Number) : void
      {
         _rank = param1;
      }
      
      public function get rawScore() : Number
      {
         return _rawScore;
      }
      
      public function set rawScore(param1:Number) : void
      {
         _rawScore = param1;
      }
   }
}

