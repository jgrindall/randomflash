class Vector {
	var x:Number;
	var y:Number;
	var z:Number;
	public function Vector(a:Number, b:Number, c:Number) {
		setV(a, b, c);
	}
	public function setV(x, y, z):Void {
		this.x = x;
		this.y = y;
		this.z = z;
	}
	public function getX():Number {
		return x;
	}
	public function getY():Number {
		return y;
	}
	public function getZ():Number {
		return z;
	}
	public function mult(lm:Number) {
		var r:Vector = new Vector(x*lm, y*lm, z*lm);
		return r;
	}
	public function multme(lm:Number) {
		x *= lm;
		y *= lm;
		z *= lm;
	}
	public function getMod():Number {
		return Math.sqrt(x*x+y*y+z*z);
	}
	public function normalize() {
		var l = getMod();
		if (l != 0) {
			mult(1/l);
		}
	}
	public function roundoff():Void{
		x=Math.round(x*100000)/100000
		y=Math.round(y*100000)/100000
		z=Math.round(z*100000)/100000
		
	}
	public function cross(w:Vector):Vector {
		var cv:Vector = new Vector(y*w.getZ()-z*w.getY(), z*w.getX()-x*w.getZ(), x*w.getY()-y*w.getX());
		return cv;
	}
	public function dot(w:Vector):Number {
		//unit vectors
		return (x*w.x+y*w.y+z*w.z);
	}
	public function traceit():Void {
		trace(rndoff(x)+","+rndoff(y)+","+rndoff(z));
	}
	public function rndoff(k:Number):Number{
		return (Math.round(k*100)/100)
	}
}
