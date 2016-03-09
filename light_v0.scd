// Enric Guaus.
// February 2016
// Audio control for the Lighting Soundscapes project (https://enricguaus.wordpress.com/portfolio/lighting-soundscapes/)
// In collaboration with Felix Pastor (https://felixpastor.wordpress.com/)
// This installation was performed in Hans & Fritz Contemporary, in Barcelona, on March 3rd, 2016.
//
// This script receives OSC messages from video processing. These messages are related to the light intensity
// from a webcam with only 16 pixels resolution. The light intensity controls the sound volume of each audio
// file on oach of the 6 scenes. The light-related intensity is controlled by the "amp" parameter in the synth.

// The 6 proposed scenes are always evolving from one to the other using a hanning function for "fade-in" and
// "fade-out". The audio os controlled by the "vol" parameter in the synth.

(
// -------------------------------------------
// ---- RUN THIS FIRST TO BOOT THE SERVER ----
// -------------------------------------------
// ---- GLOBAL VARIABLES ---
~nRows=4;
~nColumns=4;
~nScenes=6;
~sceneDuration = 3;
~qFactor = 5;
~lag = 1;
// ---- BOOT SERVER ----
s.waitForBoot({
	// ---- LOAD AUDIO BUFFERS ----
	~lightFiles = [

		            Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/people_2acceleration.wav"),
			        Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/people_2cassolada.wav"),
			        Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/people_2columpio.wav"),
			        Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/people_2diagonalmar.wav"),
			        Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/people_2dishwasher.wav"),
			        Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/people_2esquellot.wav"),
			        Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/people_2mariaaguilo.wav"),
			        Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/people_2mingling.wav"),
			        Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/people_2night.wav"),
			        Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/people_2piscina.wav"),
			        Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/people_2raining.wav"),
			        Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/people_2rondadedalt.wav"),
			        Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/people_2santantoni.wav"),
			        Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/people_2segadors.wav"),
			        Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/people_2stomping.wav"),
			        Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/people_2waves.wav"),

		            Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/inst1.wav"),
		            Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/inst2.wav"),
		            Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/inst3.wav"),
		            Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/inst4.wav"),
		            Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/inst5.wav"),
		            Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/inst6.wav"),
		            Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/inst7.wav"),
		            Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/inst8.wav"),
		            Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/inst9.wav"),
		            Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/inst10.wav"),
		            Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/inst11.wav"),
		            Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/inst12.wav"),
		            Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/inst13.wav"),
		            Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/inst4.wav"),
		            Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/inst5.wav"),
		            Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/inst6.wav"),

	                Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/religious_amen.wav"),
	                Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/religious_buddhist.wav"),
	                Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/religious_calltoprayer.wav"),
	                Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/religious_calltoprayer2.wav"),
	                Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/religious_calltoprayer3.wav"),
	                Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/religious_calltoprayer4.wav"),
	                Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/religious_flute.wav"),
	                Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/religious_mantra.wav"),
	                Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/religious_monks.wav"),
	                Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/religious_monks2.wav"),
	                Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/religious_montserrat.wav"),
	                Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/religious_ocells.wav"),
	                Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/religious_quoran.wav"),
	                Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/religious_rosary.wav"),
	                Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/religious_vespers.wav"),
	                Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/religious_whispered.wav"),

		            Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/noiz1.wav"),
		            Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/noiz2.wav"),
		            Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/noiz3.wav"),
		            Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/noiz4.wav"),
		            Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/noiz5.wav"),
		            Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/noiz6.wav"),
		            Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/noiz7.wav"),
		            Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/noiz8.wav"),
		            Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/noiz9.wav"),
		            Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/noiz10.wav"),
		            Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/noiz11.wav"),
		            Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/noiz12.wav"),
		            Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/noiz13.wav"),
		            Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/noiz14.wav"),
		            Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/noiz15.wav"),
		            Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/noiz6.wav"),

		            Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/radio1.wav"),
		            Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/radio2.wav"),
		            Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/radio3.wav"),
		            Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/radio4.wav"),
		            Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/radio5.wav"),
		            Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/radio6.wav"),
		            Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/radio7.wav"),
		            Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/radio8.wav"),
		            Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/radio9.wav"),
		            Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/radio10.wav"),
		            Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/radio11.wav"),
		            Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/radio12.wav"),
		            Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/radio13.wav"),
		            Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/radio14.wav"),
		            Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/radio15.wav"),
		            Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/radio16.wav"),

		            Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/queneau_bayo.wav"),
			        Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/queneau_costal.wav"),
			        Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/queneau_fina.wav"),
			        Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/queneau_franch.wav"),
			        Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/queneau_garcia.wav"),
			        Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/queneau_gascon.wav"),
			        Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/queneau_gonzalez.wav"),
			        Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/queneau_gutes.wav"),
			        Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/queneau_herrera.wav"),
			        Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/queneau_mercadal.wav"),
			        Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/queneau_palacios.wav"),
			        Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/queneau_pastor.wav"),
			        Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/queneau_serrano.wav"),
			        Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/queneau_tamarit.wav"),
			        Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/queneau_urrutia.wav"),
			        Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/queneau_val.wav"),

	];

	// ---- SYNTH1: AUDIO FILES ----
	SynthDef(\read_file, {arg bufnum, amp=0, gate=1, rate=1, vol=0, del=0, lr=0;
	    // "amp" is the loudness related to the light right now, changning inmediately.
	    // "vol" is the loudness related to the scene, changing through an automatic function
		var env = EnvGen.kr(Env.asr(10, 1, 3), gate, doneAction: 2) ;
		var snd = PlayBuf.ar(2, bufnum, rate, loop: 1, startPos: del, doneAction: 2);
		var pan = Balance2.ar(snd[0],snd[1],pos:lr); // ---- FER UN BON PANNING amb el POSITION, que controla angle
		Out.ar(0, env * Ramp.kr(amp,~lag) * Ramp.kr(vol,~lag) * pan);
	}).add;
});
)

(
// ----------------------------------------
// ---- RUN THIS AFTER BOOTING SERVER -----
// ----------------------------------------
// ---- GENERAL FUNCTIONS ----
~hanning={arg value, length, delay;
	var res  = 0.5 * (1 - (cos((2*pi*(value-delay))/(length))));
	res = res**~qFactor;
	res
};

~nHannings=~nScenes * ~nColumns * ~nRows;

y=~nHannings.collect{arg i;
	x=Synth.new(\read_file, [\bufnum, ~lightFiles[i],\amp,1,\vol,0,\del,rand(44100), \lr,i.linlin(0.0,~nHannings-1,-1.0,1.0)]);
};

r = Routine({
	inf.do({arg i;
		~nHannings.do({arg j;
			var valor= ~hanning.value(i,(~nHannings),j);
			var msg="loop="+i+ "; Scene="+floor(j/(~nColumns * ~nRows))+ "; Pixel="+mod((j),~nColumns*~nRows)+"; Value="+valor;
			y[j].set(\vol,valor);
			//msg.postln;
			(~sceneDuration/~nHannings).wait;
		});
	});
}).play;


// -----------------------
// ---- OSC MESSAGING ----
// -----------------------
~lightSetAmpl={arg valueFromOscMsg, channel;
	var msg = "Receiving ch " ++ channel ++ "; value " ++ valueFromOscMsg;
	msg.postln;
	~nScenes.do({arg i;
		var tmp = channel+(i*(~nRows*~nColumns));
		y[tmp].set(\amp,valueFromOscMsg.asFloat.linlin(0,255,0,1));
	});
};

o=[ OSCFunc.newMatching({|msg, time, addr, recvPort| ~lightSetAmpl.value(msg[1],0)},  '/1/R'),
	OSCFunc.newMatching({|msg, time, addr, recvPort| ~lightSetAmpl.value(msg[1],1)},  '/2/R'),
    OSCFunc.newMatching({|msg, time, addr, recvPort| ~lightSetAmpl.value(msg[1],2)},  '/3/R'),
    OSCFunc.newMatching({|msg, time, addr, recvPort| ~lightSetAmpl.value(msg[1],3)},  '/4/R'),
    OSCFunc.newMatching({|msg, time, addr, recvPort| ~lightSetAmpl.value(msg[1],4)},  '/5/R'),
    OSCFunc.newMatching({|msg, time, addr, recvPort| ~lightSetAmpl.value(msg[1],5)},  '/6/R'),
    OSCFunc.newMatching({|msg, time, addr, recvPort| ~lightSetAmpl.value(msg[1],6)},  '/7/R'),
    OSCFunc.newMatching({|msg, time, addr, recvPort| ~lightSetAmpl.value(msg[1],7)},  '/8/R'),
    OSCFunc.newMatching({|msg, time, addr, recvPort| ~lightSetAmpl.value(msg[1],8)},  '/9/R'),
    OSCFunc.newMatching({|msg, time, addr, recvPort| ~lightSetAmpl.value(msg[1],9)}, '/10/R'),
    OSCFunc.newMatching({|msg, time, addr, recvPort| ~lightSetAmpl.value(msg[1],10)}, '/11/R'),
    OSCFunc.newMatching({|msg, time, addr, recvPort| ~lightSetAmpl.value(msg[1],11)}, '/12/R'),
    OSCFunc.newMatching({|msg, time, addr, recvPort| ~lightSetAmpl.value(msg[1],12)}, '/13/R'),
    OSCFunc.newMatching({|msg, time, addr, recvPort| ~lightSetAmpl.value(msg[1],13)}, '/14/R'),
    OSCFunc.newMatching({|msg, time, addr, recvPort| ~lightSetAmpl.value(msg[1],14)}, '/15/R'),
	OSCFunc.newMatching({|msg, time, addr, recvPort| ~lightSetAmpl.value(msg[1],15)}, '/16/R')];
)


// ----------------------------
// ---- AUXILIAR FUNCTIONS ----
// ----------------------------
(
~nHannings.collect{arg i;
	y[i].set(\vol,0);
};
)

(
16.collect{arg i;
	~lightSetAmpl.value(0,i);
};
)

(
// ------------------------
// ---- CLOSE AND EXIT ----
// ------------------------
r.stop;
r.clear;
s.quit;
)