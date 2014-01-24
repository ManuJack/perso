package com.hebdo.manager.utils
{
	import com.hebdo.manager.vo.Hebdo;

	public class Config
	{
		/**
		 * FoosCore gateway 
		 */
		private var _gateway:String = "http://www.foosballquebec.com/hebdo/fooscore/";
		
		/**
		 * TODO : Externalize 
		 */
		private static const HEBDO_LIST:Vector.<Hebdo> = new <Hebdo>[
			new Hebdo("bonziniqc", "Bonzini QC Mardi"),
			new Hebdo("fireballmtl", "Fireball MTL Lundi"),
			new Hebdo("fireballriki", "Fireball Riki Mardi"),
			new Hebdo("bonzinimtl", "Bonzini MTL Mercredi"),
			new Hebdo("bonzinimtl3", "Bonzini MTL Dimanche"),
			new Hebdo("garlandotr", "Garlando TR Samedi")
		];
		
		public function Config()
		{
		}

		public function get gateway():String
		{
			return _gateway;
		}
		
		public function get hebdosList():Vector.<Hebdo>
		{
			return HEBDO_LIST;
		}

	}
}