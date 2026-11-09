package
{
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import flash.utils.ByteArray;
   
   [ExcludeClass]
   [Embed(source="/_assets/1_battstat_bat.bin", mimeType="application/octet-stream")]
   public class battstat_bat extends ByteArray
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
      
      public function battstat_bat()
      {
         wlog("battstat_bat.battstat_bat");
         super();
      }
   }
}

