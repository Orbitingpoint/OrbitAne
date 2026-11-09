package pinball.vibration
{
   import flash.external.ExtensionContext;
   
   public class VibrationExtension
   {
      
      public function VibrationExtension()
      {
         super();
      }
      
      public static function create() : ExtensionContext
      {
         return ExtensionContext.createExtensionContext("pinball.vibration","");
      }
   }
}

