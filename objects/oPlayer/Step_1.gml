/// @description Controls


#region FX Updates
	
	#region Sprite Polarity Flip
		
		#region Horizontal
			
			if(sprFlipH) {
				
				// First? Set Old...
				if(flipHi == 0) {
					
					// Set Polairty Old
					if is(imgDia) imgPolOld = imgDiaPol;
					else if(suited) imgPolOld = imgSuitPol;
					else imgPolOld = imgFacePol;
					
				} else if(imgPolOld != N) {
					
					// Apply Transistion
					if is(imgDia) imgDiaPol = lerp(imgPolOld,imgPolOld*-1,cos(degtorad(180*(flipHi/flipDel))/2));
					else if(suited) imgSuitPol = lerp(imgPolOld,imgPolOld*-1,cos(degtorad(180*(flipHi/flipDel))/2));
					else imgFacePol = lerp(imgPolOld,imgPolOld*-1,cos(degtorad(180*(flipHi/flipDel))/2));
					
				}
				
				// Iterate
				flipHi++
				if(flipHi > flipDel) {
					
					// Done?
					flipHi = 0
					sprFlipH = F
					
					// CHECKLIST:
					// I think this is done?
					// Delay Dialogue From Continuing until sprFlipH or sprFlipV is no longer true?
					// Doesn't cos(0) == 2 or 1? We wan't sin right? 1 -> -1 in lerp???
					
				}
				
			}
			
		#endregion
		
	#endregion
	
#endregion

#region Meta Updates
	
	#region Olds
		
		suitedo = suited
		
	#endregion
	
#endregion

if(D.scene_state == GAME.PLAY) {
	
	#region Zoom Toggle
		
		if(TRAN.delpct <= 0) {
			
			//if(MBRP and !D.ctrlOverride) D.zoomed = !D.zoomed;
			if(MBRP and !DBG.edit and !D.ctrlOverride) D.zoomed = !D.zoomed;
			
			if(D.zoomed) D.z = D.zmx-(D.zmx*lerp(D.diaZmn-1,D.diaZmx-1,D.diaDelPct));
			else D.z = D.zmn*lerp(D.diaZmn,D.diaZmx,D.diaDelPct);
			
			// Zoom Old (Used to return to zoom after transitions)
			D.zo = D.z
			
		}
		
	#endregion
	
}