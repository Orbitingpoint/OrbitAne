package com.distriqt.extension.gameservices.leaderboards
{
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   public class Leaderboard
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
      
      public static const SCORE_ORDER_LARGEST_FIRST:String = "largest:first";
      
      public static const SCORE_ORDER_SMALLEST_FIRST:String = "smallest:first";
      
      public static const TIME_SPAN_DAILY:String = "daily";
      
      public static const TIME_SPAN_WEEKLY:String = "weekly";
      
      public static const TIME_SPAN_ALL_TIME:String = "alltime";
      
      public static const COLLECTION_PUBLIC:String = "public";
      
      public static const COLLECTION_SOCIAL:String = "social";
      
      private var _id:String = "";
      
      private var _displayName:String = "";
      
      private var _scoreOrder:String = "largest:first";
      
      public function Leaderboard()
      {
         wlog("com.distriqt.extension.gameservices.leaderboards.Leaderboard.Leaderboard");
         super();
      }
      
      public static function fromXML(param1:XML) : Leaderboard
      {
         var _loc2_:Leaderboard = new Leaderboard();
         _loc2_.id = param1.id.text();
         _loc2_.displayName = param1.displayName.text();
         _loc2_.scoreOrder = param1.scoreOrder.text();
         return _loc2_;
      }
      
      public static function fromObject(param1:Object) : Leaderboard
      {
         var _loc2_:Leaderboard = new Leaderboard();
         _loc2_.id = param1.id;
         _loc2_.displayName = param1.displayName;
         _loc2_.scoreOrder = param1.scoreOrder;
         return _loc2_;
      }
      
      public function get id() : String
      {
         return _id;
      }
      
      public function set id(param1:String) : void
      {
         _id = param1;
      }
      
      public function get displayName() : String
      {
         return _displayName;
      }
      
      public function set displayName(param1:String) : void
      {
         _displayName = param1;
      }
      
      public function get scoreOrder() : String
      {
         return _scoreOrder;
      }
      
      public function set scoreOrder(param1:String) : void
      {
         _scoreOrder = param1;
      }
   }
}

