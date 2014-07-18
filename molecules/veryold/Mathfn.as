class Mathfn {
	public static function getdist(a:MovieClip, b:MovieClip):Number {
		var dsq:Number = (a._x-b._x)*(a._x-b._x)+(a._y-b._y)*(a._y-b._y);
		return Math.sqrt(dsq);
	}
	public static function gettheta(a:MovieClip, b:MovieClip):Number {
		if (b._x != a._x) {
			var t:Number = Math.atan((b._y-a._y)/(b._x-a._x));
			if (b._x<a._x) {
				t += Math.PI;
			}
			return t;
		}
		else {
			if (b._y>a._y) {
				return (Math.PI/2);
			}
			else {
				return (3*Math.PI/2);
			}
		}
	}
}
