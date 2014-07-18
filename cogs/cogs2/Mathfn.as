import flash.filters.DropShadowFilter;
import flash.geom.Matrix;
class Mathfn {
	public static function drawcog(mc:MovieClip, r:Number, t:Number) {
		//draws a cog shape in any movieclip
		var theta:Number;
		var g:Number = 3;
		var hole:Number = r-2*g;
		var pos:Object = new Object();
		mc.clear();
		mc.lineStyle(0.1, 0x000000, 100);
		var k, theta:Number;
		//
		var myMatrix:Matrix = new Matrix();
		myMatrix.createGradientBox(r, r, 45, 0, 0);
		var colors:Array = [0x97999B, 0x666666];
		var alphas:Array = [70, 90];
		var ratios:Array = [0, 255];
		mc.beginFill(0x97999B, 90);
		//
		var p:Object = new Object();
		p = rot(0, r-g, 0);
		mc.moveTo(p.x, p.y);
		for (k=0; k<=t-1; k++) {
			theta = 2*Math.PI/t;
			p = rot(k*theta, r-g, 0);
			mc.lineTo(p.x, p.y);
			p = rot(k*theta, (r-g)*Math.cos(theta/4), (r-g)*Math.sin(theta/4));
			mc.lineTo(p.x, p.y);
			p = rot(k*theta, (r+g)*Math.cos(theta/3), (r+g)*Math.sin(theta/3));
			mc.lineTo(p.x, p.y);
			p = rot(k*theta, (r+g)*Math.cos(2*theta/3), (r+g)*Math.sin(2*theta/3));
			mc.lineTo(p.x, p.y);
			p = rot(k*theta, (r-g)*Math.cos(3*theta/4), (r-g)*Math.sin(3*theta/4));
			mc.lineTo(p.x, p.y);
			p = rot(k*theta, (r-g)*Math.cos(theta), (r-g)*Math.sin(theta));
			mc.lineTo(p.x, p.y);
		}
		p = rot(0, r-g, 0);
		mc.lineTo(p.x, p.y);
		var num:Number = 30;
		theta = 0;
		mc.lineStyle(0.1, 0x000000, 0);
		mc.lineTo(hole*Math.cos(theta), hole*Math.sin(theta));
		mc.lineStyle(0.1, 0x000000, 30);
		for (k=1; k<=num; k++) {
			theta = (k/num)*2*Math.PI;
			mc.lineTo(hole*Math.cos(theta), hole*Math.sin(theta));
		}
		mc.lineStyle(0.1, 0x000000, 0);
		mc.lineTo(p.x, p.y);
		mc.endFill();
		//
		theta = 0;
		p = rot(0, r-g, 0);
		mc.moveTo(hole*Math.cos(theta), hole*Math.sin(theta));
		mc.lineStyle(0.1, 0x000000, 10);
		mc.beginGradientFill("linear", colors, alphas, ratios, myMatrix);
		theta = 0;
		mc.lineStyle(0.1, 0x000000, 0);
		mc.lineTo(hole*Math.cos(theta), hole*Math.sin(theta));
		mc.lineStyle(0.1, 0x000000, 10);
		for (k=1; k<=num; k++) {
			theta = (k/num)*2*Math.PI;
			mc.lineTo(hole*Math.cos(theta), hole*Math.sin(theta));
		}
		mc.lineStyle(0.1, 0x000000, 0);
		mc.lineTo(p.x, p.y);
		var hole2:Number = 5;
		theta = 0;
		mc.lineStyle(0.1, 0x000000, 0);
		mc.lineTo(hole2*Math.cos(theta), hole2*Math.sin(theta));
		mc.lineStyle(0.1, 0x000000, 100);
		for (k=1; k<=num; k++) {
			theta = (k/num)*2*Math.PI;
			mc.lineTo(hole2*Math.cos(theta), hole2*Math.sin(theta));
		}
		mc.lineStyle(0.1, 0x000000, 0);
		mc.lineTo(p.x, p.y);
		//
		theta = 0;
		mc.lineStyle(0.1, 0x000000, 0);
		mc.moveTo(hole2*Math.cos(theta), hole2*Math.sin(theta));
		mc.beginFill(0xffffff, 5);
		for (k=1; k<=num; k++) {
			theta = (k/num)*2*Math.PI;
			mc.lineTo(hole2*Math.cos(theta), hole2*Math.sin(theta));
		}
		mc.endFill();
	}
	public static function rot(a:Number, x:Number, y:Number):Object {
		var r:Object = new Object();
		r.x = Math.cos(a)*x-Math.sin(a)*y;
		r.y = Math.sin(a)*x+Math.cos(a)*y;
		return r;
	}
	public static function clearmention(a:Array, rem:Number):Array {
		var b:Array = new Array();
		for (var i:Number = 0; i<=a.length-1; i++) {
			if (a[i] != rem) {
				b.push(a[i]);
			}
		}
		return b;
	}
	public static function decrement(a:Array, ind:Number):Array {
		var ret:Array = new Array();
		for (var i:Number = 0; i<=a.length-1; i++) {
			if (a[i]>ind) {
				ret.push(a[i]-1);
			}
			else if (a[i] == ind) {
				//ignore it, its gone!
			}
			else {
				ret.push(a[i]);
			}
		}
		return ret;
	}
	public static function roundme(n:Number):Number {
		return (Math.round(n*10)/10);
	}
}
