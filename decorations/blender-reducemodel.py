import bpy, sys, os

# Take the last argument as the output path.
out_path = sys.argv[-1]

object = bpy.data.collections[0].all_objects[0]

modifier = object.modifiers.new(name="Decimate",type='DECIMATE')
modifier.decimate_type = 'DISSOLVE'
modifier.delimit = {'UV'}
modifier.angle_limit = 0.349

for texture in bpy.data.textures:
	if texture.is_embedded_data or not texture is bpy.types.ImageTexture:
		continue
	if not texture.filepath.endswith("exr"):
		continue
	texture.image.filepath = texture.filepath.replace(".exr", ".jpg")
	

bpy.ops.export_scene.gltf(
	filepath=out_path,
	export_format='GLTF_SEPARATE',
	export_image_format='JPEG',
	export_apply=True
)