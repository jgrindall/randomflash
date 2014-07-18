class Vector {
	public var x:Number;
	public var y:Number;
	public function Vector(a:Number, b:Number) {
		setV(a, b);
	}
	public function setV(x, y) {
		this.x = x;
		this.y = y;
	}
	public function mult(lm:Number) {
		var r:Vector = new Vector(x*lm, y*lm);
		return r;
	}
	public function multme(lm:Number) {
		x *= lm;
		y *= lm;
	}
	public function getMod():Number {
		return Math.sqrt(x*x+y*y);
	}
	public function traceit():Void {
		trace(x+","+y);
	}
}
