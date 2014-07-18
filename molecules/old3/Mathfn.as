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
	public static function add_array(x:Number, a:Array):Array {
		var r:Array = new Array(a.length);
		for (var i:Number = 0; i<=a.length-1; i++) {
			r[i] = a[i]+x;
		}
		return r;
	}
	public static function delete_occur(x:Number, a:Array):Array {
		//delete occurences of number x and reduce and any greater than x by 1
		var r:Array = new Array();
		for (var i:Number = 0; i<=a.length-1; i += 2) {
			if (a[i] == x || a[i+1] == x) {
			}
			else {
				//adjust them
				if (a[i]<x) {
					r.push(a[i]);
				}
				if (a[i]>x) {
					r.push(a[i]-1);
				}
				if (a[i+1]<x) {
					r.push(a[i+1]);
				}
				if (a[i+1]>x) {
					r.push(a[i+1]-1);
				}
			}
		}
		return r;
	}
	public static function remove_array(x:Number, a:Array):Array {
		//deletes indexes x from double array.
		//eg  remove 3 from 0,0,1,1,2,2,3,3,4,4,5,5,6,6  ---->   0,0,1,1,2,2,4,4,5,5,6,6
		return (a.slice(0, 2*x).concat(a.slice(2*(x+1), a.length)));
	}
}
