package com.distriqt.extension.gameservices.multiplayer
{
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   public class PlayerSelectionOptions
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
      
      public var minPlayers:int = 1;
      
      public var maxPlayers:int = 3;
      
      public var allowAutomatch:Boolean = true;
      
      public function PlayerSelectionOptions()
      {
         wlog("com.distriqt.extension.gameservices.multiplayer.PlayerSelectionOptions.PlayerSelectionOptions");
         super();
      }
   }
}

