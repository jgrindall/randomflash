class Line {
	public var n0, n1:Node;
	public var mymc:MovieClip;
	private var natL:Number;
	private static var lambda:Number = 0.02;
	function Line(mymc:MovieClip, n0:Node, n1:Node) {
		this.n0 = n0;
		this.n1 = n1;
		this.mymc = mymc;
		natL=50;
		//natL = Mathfn.getdist(n0.mymc, n1.mymc);
		drawme();
	}
	public function drawme() {
		mymc.clear();
		mymc.lineStyle(1, 0x000000, 100);
		mymc.moveTo(n0.x, n0.y);
		mymc.lineTo(n1.x, n1.y);
	}
	public function gettension():Number {
		var L:Number = Mathfn.getdist(n0.mymc, n1.mymc);
		var extension:Number = L-natL;
		var t:Number = lambda*extension;
		return t;
	}
}
