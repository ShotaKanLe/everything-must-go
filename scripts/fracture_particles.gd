extends GPUParticles3D

func explode(target_mesh: Mesh, target_material: Material) -> void:
	draw_pass_1 = target_mesh
	if target_material:
		set_material_override(target_material)
	
	# 1. Konfigurasi Dasar Node GPUParticles3D via Kode
	amount = 15
	lifetime = 1.0
	one_shot = true
	explosiveness = 1.0
	
	# 2. Membuat dan Mengonfigurasi ParticleProcessMaterial via Kode
	var material := ParticleProcessMaterial.new()
	
	material.direction = Vector3(0, 1, 0)
	material.spread = 180.0
	
	material.initial_velocity_min = 3.0
	material.initial_velocity_max = 6.0
	
	material.gravity = Vector3(0, -9.8, 0)
	
	# 3. Membuat Kurva Ukuran (Scale Curve) Agar Pecahan Mengecil Lalu Menghilang
	var curve := Curve.new()
	curve.add_point(Vector2(0.0, 1.0)) # Ukuran penuh (1.0) di awal animasi (0.0)
	curve.add_point(Vector2(1.0, 0.0)) # Ukuran habis (0.0) di akhir animasi (1.0)
	
	var curve_texture := CurveTexture.new()
	curve_texture.curve = curve
	
	material.scale_curve = curve_texture
	
	# Pasang material yang dibuat ke partikel ini
	process_material = material
	
	# Mulai ledakan
	emitting = true
	
	var timer := get_tree().create_timer(lifetime + 0.5)
	timer.timeout.connect(queue_free)
