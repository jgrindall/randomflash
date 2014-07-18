class Cannon {
	private var maxtimer:Number = 700;
	private var explosion:Number = 600;
	private var timer:Number;
	private var mc:MovieClip;
	public var alight:Boolean;
	function Cannon() {
		timer = 0;
		alight = false;
		mc = _root.cannon;
		var t:Cannon = this;
		mc.onEnterFrame = function() {
			if (t.alight) {
				t.timer++;
				t.setframe();
				if (t.timer == t.explosion) {
					t.bang();
				}
				else if (t.timer == t.maxtimer) {
					t.stopall();
				}
			}
		};
	}
	private function setframe():Void {
		var fn:Number;
		fn = Math.round((timer/maxtimer)*mc._totalframes);
		mc.gotoAndStop(fn);
	}
	private function bang():Void {
		_root.addball();
	}
	public function light():Void {
		if (!alight) {
			alight = true;
			timer = 0;
		}
	}
	private function stopall():Void {
		alight = false;
		timer = 0;
		mc.gotoAndStop(1);
	}
}
