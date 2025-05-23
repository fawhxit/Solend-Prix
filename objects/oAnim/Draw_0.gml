/// @description Animation


if(D.game_state == GAME.PLAY
    and D.scene_state == GAME.PLAY
    and D.animPlay = id
    and is(animStr)) {
	
	if(is(diaInst[$ NS[$ K.I]])) {
		
		#region Blackout
			
			draw_set_alpha(1)
			draw_rectangle_color(0,0,WW,WH,c.blk,c.blk,c.blk,c.blk,F)
			
		#endregion
		
		#region Light FX Sets...
			
			if(lightFX) {
				
				if(fxInst.blend) {
					
					if(variable_instance_exists(fxInst,"lpct"))
						image_blend = lerp_color(c.wht,fxInst.blendc,delta_pct(0,.5,fxInst.lpct));
					else image_blend = fxInst.blendc;
					
				}
				
			} else image_blend = c.wht;
			
		#endregion
		
		#region Apply Sprites...
			
			if(variable_instance_exists(diaInst,K.BD0+K.SPR)) {
				
				draw_sprite_ext(diaInst[$ K.BD0+K.SPR],0,xbd,ybd,image_xscale,image_yscale,0,image_blend,1)
				
			}
			
			#region Light FX Pre (Darkness Layer for BD0)
				
				if(lightFX) fx_pre(fxInst);
				
			#endregion
			
			if(variable_instance_exists(diaInst,K.SP0+K.SPR)) {
				
				draw_sprite_ext(diaInst[$ K.SP0+K.SPR],0,xship,yship,image_xscale/2,image_yscale/2,0,image_blend,1)
				
			}
			
			if(variable_instance_exists(diaInst,K.BG0+K.SPR)) {
				
				if(is_array(diaInst[$ K.BG0+K.SPR]) and !arrSprDone) {
					
					#region BG0 Sprite Array
						
						try {
							
							#region Init arrSpr Delay/Delay Iterator
								
								if(!arrSpri) {
									
									arrSpri = 0
									var sprs = []
									for(var i2 = 0; i2 <= array_length(diaInst[$ K.BG0+K.SPR])-2; i2+=2) sprs[array_length(sprs)] = diaInst[$ K.BG0+K.SPR][i2];
									if(sprs != []) sprite_prefetch_multi(sprs);
									
								}
								if(!arrSprDel and arrSpri <= array_length(diaInst[$ K.BG0+K.SPR])-2) {
									
									arrSprDel = diaInst[$ K.BG0+K.SPR][arrSpri+1][0]*GSPD // Ensure Delay Set...
									arrSprDeli = 0
									
								}
								
							#endregion
							
							#region Iterate arrSpr
								
								if(arrSprDeli >= arrSprDel or n_fxi >= arrSprDel) {
									
									if(arrSpri <= array_length(diaInst[$ K.BG0+K.SPR])-2) {
										
										#region More to go...
											
											arrSprDeli = 0
											arrSpri += 2 // Go to next sprite in array, skip over index with delay value
											arrSprDel = diaInst[$ K.BG0+K.SPR][arrSpri+1][0]*GSPD
											if(!is_undefined(n_z)) n_z = U;
											if(!is_undefined(n_aln)) n_aln = U;
											if(!is_undefined(n_fxi)) n_fxi = U;
											if(!is_undefined(n_vel)) n_vel = U;
											if(!is_undefined(n_zmx)) n_zmx = U;
											if(!is_undefined(n_col)) n_col = U;
											
											if(!is_undefined(n_z)) {
												
												n_z = 1
												n_fxi = 0
												// Resize
												if(tightPan) scl = ((WW*1.1)*n_z)/sprite_get_width(NS[$ animStr][$ K.BG0+K.SPR][arrSpri])
												else scl = ((WW*D.zmn)*n_z)/sprite_get_width(NS[$ animStr][$ K.BG0+K.SPR][arrSpri])
												
											} else {
												
												// Resize
												if(tightPan) scl = (WW*1.1)/sprite_get_width(NS[$ animStr][$ K.BG0+K.SPR][arrSpri])
												else scl = (WW*D.zmn)/sprite_get_width(NS[$ animStr][$ K.BG0+K.SPR][arrSpri])
												
											}
											
										#endregion
										
									} else {
										
										#region Done...
											
											arrSprDeli = N
											arrSpri = N
											arrSprDel = N
											arrSprDone = T
											
										#endregion
										
									}
									
								} else arrSprDeli++;
								
							#endregion
							
							#region Draw Current Array Sprite...
								
								if(arrSprDeli != N) {
									
									if(!is_undefined(n_col)) image_blend = n_col;
									else image_blend = c.wht;
									
									if(!is_undefined(n_z)) draw_sprite_ext(diaInst[$ K.BG0+K.SPR][arrSpri],0,xbg,ybg,scl*n_z,scl*n_z,0,image_blend,1);
									else draw_sprite_ext(diaInst[$ K.BG0+K.SPR][arrSpri],0,xbg,ybg,scl,scl,0,image_blend,1);
									
								}
								
							#endregion
							
						} catch(_ex) {
							
							#region Done...
								
								arrSprDeli = N
								arrSpri = N
								arrSprDel = N
								arrSprDone = T
								
							#endregion
							
						}
						
					#endregion
					
				} else if(!is_array(diaInst[$ K.BG0+K.SPR])) draw_sprite_ext(diaInst[$ K.BG0+K.SPR],0,xbg,ybg,image_xscale,image_yscale,0,image_blend,1);
				
			}
			
		#endregion
		
		draw_self()
		
		#region Light FX Iter
			
			if(lightFX) fx_iter(fxInst);
			
		#endregion
		
		#region SKS Actions (Beginning Only)
			
			if(diaInst[$ K.I] == 0 and D.animPlay == id) {
				
				var sks = variable_instance_get_sorted_strKeys(diaInst,F)
				for(var i = 0; i < array_length(sks); i++) {
					
					#region SKS Names
						
						var _sndsp = K.SND+K.STP
						var _sndpl = K.SND+K.PLY
						
					#endregion
					
					#region Init
						
						var k = sks[i]
						var v = diaInst[$ k]
						
					#endregion
					
					switch(k) {
						
						#region Sound
							
							case _sndsp:
								
								if(!is_array(v) and audio_exists(v)) {
									
									#region Single Sound Entry
										
										if(audio_is_playing(v)) {
											
											if(audio_sound_get_gain(v) >= 2/3) audio_sound_gain(v,0,1000);
											else if(audio_sound_get_gain(v) <= 0) audio_stop_sound(v);
											
										}
										
									#endregion
									
								} else {
									
									#region Array Process TODO
										
										//TODO
										
									#endregion
									
								}
								
							break
							
							case _sndpl:
								
								if(!is_array(v) and audio_exists(v)) {
									
									#region Single Sound Entry
										
										// Don't start a new sound if while we stop another...
										if(array_contains(sks,_sndsp)) sndStp = !audio_is_playing(diaInst[$ _sndsp]);
										
										if(is_undefined(sndStp) or sndStp) {
											
											var snd = N
											if(!audio_is_playing(v)) snd = audio_play_sound_on(envEmt,v,T,3,0);
											if(snd != N) audio_sound_gain(snd,1,1000);
											
										}
										
									#endregion
									
								} else {
									
									#region Array Process TODO
										
										//TODO
										
									#endregion
									
								}
								
							break
							
						#endregion
						
					}
					
				}
				
			}
			
		#endregion
		
		#region Anim End...
			
			var _nxt = N
			if(variable_instance_exists(diaInst,K.ANM+K.NXT)) _nxt = diaInst[$ K.ANM+K.NXT];
			if(diaInst[$ K.DN] and !is_string(_nxt)) TRAN.from_anim = id; // No Next Anim; Normal Close
			else if(diaInst[$ K.DN] and is_string(_nxt)) {
				
				diaNar_anim_start(_nxt)
				instance_destroy(id)
				
			}
			
		#endregion
		
	}
    
}