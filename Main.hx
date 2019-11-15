import h3d.Engine;
import h3d.mat.DepthBuffer;
import h3d.mat.Texture;
import h3d.mat.Material;
import h3d.Vector;
import h3d.scene.*;

class Main extends hxd.App {
	var time:Float = 0.;
	var virtualScreen:Mesh;
	var cube:Mesh;
	var s3dTarget:Scene;
	var renderTarget:Texture;
	var virtualCamera:h3d.Camera;

	override function init() {
		super.init();

		var virtualWidth = 128;
		var virtualHeight = 96;
		
		s3d.camera.pos = new Vector(0, -0.0000001, 0);
		// creates a new unit cube

		renderTarget = new Texture(virtualWidth, virtualHeight, [Target]);
		renderTarget.filter = Nearest;
		renderTarget.depthBuffer = new DepthBuffer(virtualWidth, virtualHeight);

		var screenPrim = new h3d.prim.Cube(virtualWidth, virtualHeight, 0, true);
		screenPrim.unindex();
		screenPrim.addNormals();
		screenPrim.addUVs();
		
		var mat = h3d.mat.Material.create(renderTarget);
		virtualScreen = new Mesh(screenPrim, mat, s3d);
		virtualScreen.material.shadows = false;
		virtualScreen.material.mainPass.enableLights = false;

		s3dTarget = new h3d.scene.Scene();
		virtualCamera = new h3d.Camera();

		virtualCamera.pos.z = 5;
		s3dTarget.camera = virtualCamera;

		var prim = new h3d.prim.Cube(1, 1, 1, true);
		prim.unindex();
		prim.addNormals();
		prim.addUVs();
		var tex = hxd.Res.obama.toTexture();
		tex.filter = Nearest;
		cube = new Mesh(prim, Material.create(tex), s3d);

		s3dTarget.addChild(cube);

		var light = new h3d.scene.fwd.DirLight(new h3d.Vector(0.5, 0.5, -0.5), s3d);
		light.enableSpecular = true;

		// disable shadows
		virtualScreen.material.shadows = false;
		cube.material.shadows = false;
		cube.material.mainPass.enableLights = false;

		s3d.camera.setFovX(80, 1.633333);

		s3dTarget.addChild(cube);

		var bounds = virtualScreen.getBounds().getSize();
		var dist = Math.max(Math.max(bounds.x, bounds.y), bounds.z);
		dist /= (2.0 * Math.tan(0.5 * s3d.camera.getFovX() * (Math.PI / 180)));
		s3d.camera.pos.z = dist;
	}

	override function render(e:Engine) {
		// super.render(e);
		engine.pushTarget(renderTarget);
		engine.clear(0, 1);
		s3dTarget.render(e);
		engine.popTarget();
		// Now render our scene
		s3d.render(e);
		s2d.render(e);
	}

	override function update(dt:Float) {
		super.update(dt);
		// time is flying...
		time += 0.6 * dt;
		// move the camera position around the two cubes
		var dist = 5;
		// s3d.camera.pos.set(Math.cos(time) * dist, Math.sin(time) * dist, dist * 0.7 * Math.sin(time));
		cube.setRotationAxis(-0.5, 2, Math.cos(time), time + Math.PI / 2);
		// rotate the second cube along a given axis + angle
		// cube.setRotationAxis(-0.5, 2, Math.cos(time), time + Math.PI / 2);
	}

	static function main() {
		// initialize embeded ressources
		hxd.Res.initEmbed();

		// start the application
		new Main();
	}
}
