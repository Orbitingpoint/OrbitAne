package com.distriqt.extension.application
{
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   public class OperatingSystem
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
      
      public var name:String = "";
      
      public var type:String = "";
      
      public var version:String = "";
      
      public var api_level:int = 0;
      
      public function OperatingSystem(param1:Object = null)
      {
         wlog("com.distriqt.extension.application.OperatingSystem.OperatingSystem");
         super();
         if(param1)
         {
            if(param1.hasOwnProperty("name"))
            {
               this.name = param1.name;
            }
            if(param1.hasOwnProperty("type"))
            {
               this.type = param1.type;
            }
            if(param1.hasOwnProperty("version"))
            {
               this.version = param1.version;
            }
            if(param1.hasOwnProperty("api_level"))
            {
               this.api_level = param1.api_level;
            }
         }
      }
   }
}

