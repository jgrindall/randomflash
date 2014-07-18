class Link {
	private var myLength:Number;
	private var father:Link;
	//centre
	private var theta:Number;
	private var speed:Number;
	private var thickness:Number = 3;
	var radius:Number = 1;
	private var color:Number;
	private var cont:MovieClip;
	private var ind:Number;
	private var cx, cy:Number;
	private var endx, endy:Number;
	private static var root2:Number = Math.sqrt(2);
	//
	public function Link(f:Link, t:Number, l:Number, s:Number, base:MovieClip, i:Number, c:Number) {
		setLength(l);
		setSpeed(s);
		theta = t;
		father = f;
		ind = i;
		color = c;
		base.createEmptyMovieClip("linkmc_"+ind, ind);
		cont = eval("base.linkmc_"+ind);
		update();
	}
	public function hidemc():Void {
		cont._visible = false;
	}
	public function showmc():Void {
		cont._visible = true;
	}
	public function setLength(l:Number):Void {
		myLength = l;
		update();
	}
	public function setSpeed(s:Number):Void {
		speed = s;
	}
	public function setEndxy() {
		endx = cx+myLength*Math.cos(theta);
		endy = cy-myLength*Math.sin(theta);
	}
	public function setCxy() {
		if (father == null) {
			cx = 250;
			cy = 400;
		}
		else {
			cx = father.getEndx();
			cy = father.getEndy();
		}
	}
	public function setAngle(a:Number) {
		theta = a;
		update();
	}
	public function getEndx():Number {
		return endx;
	}
	public function getEndy():Number {
		return endy;
	}
	public function getMyLength():Number {
		return myLength;
	}
	public function getTheta():Number {
		return theta;
	}
	public function drawMe():Void {
		cont.clear();
		cont.lineStyle(0.01, 0x000000, 100);
		//arc1
		var dhoriz:Number = thickness*root2*Math.cos(theta+(Math.PI/4));
		var dvertic:Number = thickness*root2*Math.sin(theta+(Math.PI/4));
		cont.moveTo(endx+dhoriz, endy-dvertic);
		cont.beginFill(color, 100);
		cont.lineTo(cx-dvertic, cy-dhoriz);
		cont.lineTo(cx-dhoriz, cy+dvertic);
		cont.lineTo(endx+dvertic, endy+dhoriz);
		cont.lineTo(endx+dhoriz, endy-dvertic);
		cont.endFill();
		//circles
		var t:Number = 0;
		cont.moveTo(endx+Math.cos(t)*radius, endy+Math.sin(t)*radius);
		for (t=0; t<=2*Math.PI; t += 0.1) {
			cont.lineTo(endx+Math.cos(t)*radius, endy+Math.sin(t)*radius);
		}
		t = 0;
		cont.moveTo(cx+Math.cos(t)*radius, cy+Math.sin(t)*radius);
		for (t=0; t<=2*Math.PI; t += 0.1) {
			cont.lineTo(cx+Math.cos(t)*radius, cy+Math.sin(t)*radius);
		}
	}
	public function rotate():Void {
		theta += speed;
		update();
	}
	public function destroy() {
		cont.clear();
		cont.removeMovieClip();
	}
	public function update():Void {
		setCxy();
		setEndxy();
		drawMe();
	}
}
