// Enric Guaus.
// February 2016
// Audio control for the Lighting Soundscapes project (https://enricguaus.wordpress.com/portfolio/lighting-soundscapes/)
// In collaboration with Felix Pastor (https://felixpastor.wordpress.com/)

(
// -------------------------------------------
// ---- RUN THIS FIRST TO BOOT THE SERVER ----
// -------------------------------------------
// ---- GLOBAL VARIABLES ---
~nRows=4;
~nColumns=4;
~nScenes=3;
~sceneDuration = 1;
~qFactor = 4;
// ---- BOOT SERVER ----
s.waitForBoot({
	// ---- LOAD AUDIO BUFFERS ----
	~lightFiles = [
		            Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/inst1.wav"),
		            Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/inst2.wav"),
		            Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/inst3.wav"),
		            Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/inst4.wav"),
		            Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/inst5.wav"),
		            Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/inst6.wav"),
		            Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/inst7.wav"),
		            Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/inst8NO.wav"),
		            Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/inst9NO.wav"),
		            Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/inst10NO.wav"),
		            Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/inst11NO.wav"),
		            Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/inst12NO.wav"),
		            Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/inst13NO.wav"),
		            Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/inst15NO.wav"),
		            Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/inst16NO.wav"),
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
		            Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/radio15.wav"),
		            Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/radio16.wav"),
	                Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/religious_amen.wav"),
	                Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/religious_calltoprayer.wav"),
	                Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/religious_flute.wav"),
	                Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/religious_montserrat.wav"),
	                Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/religious_ocells.wav"),
	                Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/religious_buddhist.wav"),
	                Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/religious_calltoprayer2.wav"),
	                Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/religious_calltoprayer3.wav"),
	                Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/religious_mantra.wav"),
	                Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/religious_monks.wav"),
	                Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/religious_monks2.wav"),
	                Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/religious_praywhispered.wav"),
	                Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/religious_quoran.wav"),
	                Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/religious_quoran2.wav"),
	                Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/religious_rosary.wav"),
	                Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/light_soundscape/wav/religious_vespers.wav")];

	// ---- SYNTH1: AUDIO FILES ----
	SynthDef(\read_file, {arg bufnum, amp=0, gate=1, rate=1, vol=0, del=0, lr=0;
	    // "amp" is the loudness related to the light right now, changning inmediately.
	    // "vol" is the loudness related to the scene, changing through an automatic function
		var env = EnvGen.kr(Env.asr(10, 1, 3), gate, doneAction: 2) ;
		var snd = PlayBuf.ar(2, bufnum, rate, loop: 1, startPos: del, doneAction: 2);
		var pan = Balance2.ar(snd[0],snd[1],pos:lr); // ---- FER UN BON PANNING amb el POSITION, que controla angle
		Out.ar(0, env * amp * vol * pan);
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
	x=Synth.new(\read_file, [\bufnum, ~lightFiles[i],\amp,1,\vol,0,\del,rand(44100),\position,i.linlin(0.0,~nHannings-1,-1.0,1.0)]);
};

r = Routine({
	inf.do({arg i;
		~nHannings.do({arg j;
			var valor= ~hanning.value(i,(2*~nHannings),j);
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
	~nScenes.do({arg i;
		var tmp = channel+(i*(~nRows*~nColumns));
		tmp.postln;
		y[tmp].set(\amp,valueFromOscMsg.asFloat.linlin(0,127,0,1))
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