package com.cp.sf.worlds 
{
	import com.cp.sf.entities.char_create.CharDoneButton;
	import com.cp.sf.entities.char_create.CharNameInput;
	import com.cp.sf.entities.char_create.CharRadioButton;
	import com.cp.sf.GFX;
	import com.cp.sf.GV;
	import com.cp.sf.SoundManager;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.World;
	import ui.RadioButtonGroup;
	
	/**
	 * ...
	 * @author 
	 */
	public class CharCreateWorld extends World 
	{
		protected var nameInput:CharNameInput;
		
		protected var genderGroup:RadioButtonGroup;
		protected var q1Group:RadioButtonGroup;
		protected var q2Group:RadioButtonGroup;
		protected var q3Group:RadioButtonGroup;
		protected var q4Group:RadioButtonGroup;
		protected var q5Group:RadioButtonGroup;
		
		public function CharCreateWorld() 
		{
			
		}
		
		override public function begin():void
		{
			addGraphic(new Image(GFX.GFX_CREATE_MENU_BG),10);
			
			nameInput = new CharNameInput(163, 113, "", false, 400,50);
			nameInput.layer = 0;
			add(nameInput);
			
			genderGroup = new RadioButtonGroup();
			add(new CharRadioButton(229, 166, genderGroup, "male", 25,25));
			add(new CharRadioButton(345, 166, genderGroup, "female", 25, 25));
			
			q1Group = new RadioButtonGroup();			
			add(new CharRadioButton(402, 285, q1Group, "", 25,25));
			add(new CharRadioButton(465, 285, q1Group, "", 25, 25));
			add(new CharRadioButton(527, 285, q1Group, "", 25, 25));
			add(new CharRadioButton(585, 285, q1Group, "", 25, 25));
			add(new CharRadioButton(642, 285, q1Group, "", 25, 25));
			
			q2Group = new RadioButtonGroup();			
			add(new CharRadioButton(402, 335, q2Group, "", 25,25));
			add(new CharRadioButton(465, 335, q2Group, "", 25, 25));
			add(new CharRadioButton(527, 335, q2Group, "", 25, 25));
			add(new CharRadioButton(585, 335, q2Group, "", 25, 25));
			add(new CharRadioButton(642, 335, q2Group, "", 25, 25));
			
			q3Group = new RadioButtonGroup();			
			add(new CharRadioButton(402, 391, q3Group, "", 25,25));
			add(new CharRadioButton(465, 391, q3Group, "", 25, 25));
			add(new CharRadioButton(527, 391, q3Group, "", 25, 25));
			add(new CharRadioButton(585, 391, q3Group, "", 25, 25));
			add(new CharRadioButton(642, 391, q3Group, "", 25, 25));
			
			q4Group = new RadioButtonGroup();			
			add(new CharRadioButton(402, 445, q4Group, "", 25,25));
			add(new CharRadioButton(465, 445, q4Group, "", 25, 25));
			add(new CharRadioButton(527, 445, q4Group, "", 25, 25));
			add(new CharRadioButton(585, 445, q4Group, "", 25, 25));
			add(new CharRadioButton(642, 445, q4Group, "", 25, 25));
			
			q5Group = new RadioButtonGroup();			
			add(new CharRadioButton(402, 498, q5Group, "test", 25,25));
			add(new CharRadioButton(465, 498, q5Group, "test2", 25, 25));
			add(new CharRadioButton(527, 498, q5Group, "test2", 25, 25));
			add(new CharRadioButton(585, 498, q5Group, "test2", 25, 25));
			add(new CharRadioButton(642, 498, q5Group, "test2", 25, 25));
			
			add(new CharDoneButton(630, 560, GFX.GFX_CREATE_DONE_BUTTON, 80, 30, nextScene));
			
			SoundManager.currentMusic = SoundManager.music_char_create;
			
			super.begin();
		}
		
		override public function update():void
		{
			
			super.update();
		}
		
		private function nextScene():void
		{
			GV.playerGender = genderGroup.selected;
			FP.world = new IntroWorld(6);
		}
		
	}

}