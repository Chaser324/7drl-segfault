package ui 
{
	public class RadioButton extends Checkbox 
	{
		internal var group:RadioButtonGroup;
		
		public var data:String;
		
		public function RadioButton(x:Number=0, y:Number=0, group:RadioButtonGroup = null, text:String = "", width:Number = 150, height:Number = 50, params:Object = null, checked:Boolean = false) 
		{
			super(x, y, text, width, height, null, params, checked);
			
			data = text;
			
			if (group) group.add(this);
		}
		
		override public function click():void 
		{
			group.click(this, params);
		}
		
		override public function removed():void 
		{
			super.removed();
			
			group.remove(this);
		}
	}
}