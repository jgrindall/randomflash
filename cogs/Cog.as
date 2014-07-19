class Cog {
	public var x, y:Number;
	private var r:Number;
	//radius
	public var cont:MovieClip;
	//containing movieclip
	public var ind:Number;
	//index (in _root.cogs array)
	public var discnum:Number;
	//type/size of cog
	private var teeth:Number;
	private var drag:Boolean = false;
	public var rot:Number;
	//angle of rotation
	public var inplace:Boolean;
	//are you snapped onto the board or not?
	public var placed:Vector;
	public var contacts:Array;
	//what do you touch?
	public var speed:Number;
	public var speedset:Boolean;
	//is the speed set yet?
	function Cog(m:MovieClip, i:Number, x:Number, y:Number, discnum:Number, r:Number, t:Number, sd:Boolean) {
		speed = 0;
		speedset = false;
		contacts = new Array();
		inplace = false;
		rot = 0;
		teeth = t;
		ind = i;
		this.x = x;
		this.y = y;
		this.r = r;
		this.discnum = discnum;
		cont = m.createEmptyMovieClip("cont_"+(ind+10), ind+10);
		cont.createEmptyMovieClip("cog", 0);
		cont.attachMovie("reddot", "reddot", 1);
		setred();
		//cont.createTextField("label", 3, 0, 0, 5, 5);
		//cont.label.autoSize = true;
		//cont.label.text = ind;
		//cont.label.selectable = false;
		cont.createEmptyMovieClip("hint", 2);
		cont.hint._visible = false;
		makecodehint();
		Mathfn.drawcog(cont.cog, r, teeth);
		cont.cacheAsBitmap = true;
		cont._x = x;
		cont._y = y;
		pressfn();
		//sd = should i start dragging, or not? (has it been created from scratch or after deleting one?
		if (sd) {
			start_drag();
		}
		else {
			inplace = true;
		}
	}
	private function makecodehint():Void {
		cont.hint.lineStyle(0.1, 0x000000, 100);
		cont.hint.moveTo(10, 10);
		cont.hint.beginFill(0xFFFFFFCC, 100);
		cont.hint.lineTo(140, 10);
		cont.hint.lineTo(140, 30);
		cont.hint.lineTo(10, 30);
		cont.hint.lineTo(10, 10);
		cont.hint.endFill();
		cont.hint.createTextField("hintbox", 1, 10, 11, 5, 5);
		cont.hint.hintbox.autoSize = true;
		cont.hint.hintbox.selectable = false;
		var my_fmt:TextFormat = new TextFormat();
		my_fmt.size = 10;
		my_fmt.font = "Verdana";
		my_fmt.color = 0x000000;
		cont.hint.hintbox.type = "dynamic";
		cont.hint.hintbox.setNewTextFormat(my_fmt);
	}
	public function myobject():Object {
		//used for storing all data when they are deleted and refreshed.
		var ret:Object = new Object();
		ret.x = x;
		ret.y = y;
		ret.placed = placed;
		ret.r = r;
		ret.discnum = discnum;
		ret.teeth = teeth;
		ret.rot = rot;
		ret.contacts = contacts;
		return ret;
	}
	private function setred():Void {
		cont.reddot._x = (r-7)*Math.cos(rot);
		cont.reddot._y = (r-7)*Math.sin(rot);
	}
	public function addcontact(c:Number) {
		contacts.push(c);
	}
	private function clearothers():Void {
		var i:Number;
		for (i=0; i<=contacts.length-1; i++) {
			_root.clearmention(contacts[i], ind);
		}
	}
	private function setcontacts(a:Array):Void {
		contacts = new Array();
		for (var i:Number = 0; i<=a.length-1; i++) {
			contacts.push(a[i]);
		}
	}
	private function start_drag():Void {
		if (contacts.length<=1 && !_root.turning && _root.cogon != ind) {
			//if it has 2 contacts then you cant move it otherwise you can.
			if (inplace) {
				//adjust my contacts.
				clearothers();
				_root.recycle(2);
				contacts = new Array();
				inplace = false;
				_root.clearpin(placed);
				_root.setallpos();
			}
			_root.showall(discnum);
			cont.startDrag(true, -100, -100, 1000, 1000);
			drag = true;
		}
	}
	public function setrot(alpha0:Number, q:Number, r:Number):Void {
		var qnew:Number = q-r;
		var x:Number = qnew-alpha0*Math.floor(qnew/alpha0);
		var h:Number = x/(alpha0/2);
		//h is now between 0 and 2, it measures the phase we are at.
		var myrot:Number = f(h)*(2*Math.PI/teeth)/2;
		rot = adjustangle(Math.PI+q-myrot);
		rotateme();
	}
	private function f(h:Number):Number {
		if (h<=1) {
			return (1-h);
		}
		else {
			return (3-h);
		}
	}
	private function rotateme():Void {
		cont.cog._rotation = 180*rot/Math.PI;
		setred();
	}
	public function setspeed(s:Number) {
		speedset = true;
		speed = s;
		var i:Number;
		var neigh:Cog;
		for (i=0; i<=contacts.length-1; i++) {
			neigh = _root.cogs[contacts[i]];
			if (!neigh.speedset) {
				neigh.setspeed(-s*teeth/neigh.teeth);
			}
		}
	}
	private function pressfn() {
		var t:Cog = this;
		cont.cog.onPress = function() {
			t.start_drag();
		};
		cont.cog.onMouseUp = function() {
			if (t.drag) {
				t.stop_drag();
			}
			if (t.cont.hint._visible) {
				t.hidecodehint();
			}
		};
		cont.cog.onRollOver = function() {
			t.showcodehint();
		};
		cont.cog.onRollOut = function() {
			t.hidecodehint();
		};
		cont.cog.onDragOut = function() {
			t.hidecodehint();
		};
	}
	private function hidecodehint():Void {
		cont.hint.tbox.text = "";
		cont.hint._visible = false;
	}
	private function showcodehint():Void {
		if (_root.turning) {
			var rpm:Number = Mathfn.roundme((1000/_root.time_ms)*60*speed);
			if (rpm>=0) {
				cont.hint.hintbox.text = rpm+" rpm clockwise";
			}
			else {
				cont.hint.hintbox.text = Math.abs(rpm)+" rpm anticlockwise";
			}
			cont.hint._visible = true;
			cont.swapDepths(100);
		}
	}
	public function setpos(v:Vector):Void {
		inplace = true;
		placed = v;
		cont._x = x;
		cont._y = y;
	}
	private function stop_drag():Void {
		stopDrag();
		_root.recycle(1);
		drag = false;
		x = _xmouse;
		y = _ymouse;
		_root.snap(this);
	}
	public function resetspeed():Void {
		speedset = false;
		speed = 0;
	}
	private function adjustangle(x:Number):Number {
		if (x<0) {
			x += 2*Math.PI;
		}
		if (x>2*Math.PI) {
			x -= 2*Math.PI;
		}
		return x;
	}
	public function turnme():Void {
		rot = adjustangle(rot+speed);
		rotateme();
	}
	public function deleteme():Void {
		removeMovieClip(cont);
		delete this;
	}
}
