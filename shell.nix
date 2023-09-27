{ pkgs ? import <nixpkgs> {} }:
(pkgs.buildFHSUserEnv {
	name = "Godot";
	multiPkgs = pkgs: with pkgs; [
		xorg.libX11
		xorg.libXext
		xorg.libX11
		xorg.libXrandr
		mesa_glu
		xorg.libXcursor
		xorg.libXinerama
		xorg.libXrender
		xorg.libXi
		libGL
	];
	runScript = "bash";
}).env
