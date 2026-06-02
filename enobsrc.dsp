// faust2lv2 -double enobsrc.dsp  &&  sed -i -e 's/out0/Quantized/g' -e 's/out1/QuantizedMicro/g' -e 's/out2/Straight/g' -e 's/out3/StraightMicro/g' -e 's/out4/UNUSED0/g' -e 's/out5/UNUSED1/g' -e '/lv2:name "Comb/a\\tlv2:portProperty lv2:integer ;' -e '/lv2:name "Bits/a\\tlv2:portProperty lv2:integer ;' enobsrc.lv2/enobsrc.ttl  &&  cp -R ./enobsrc.lv2/ /usr/local/lib/lv2/

declare name "ENOBSrc"; // No spaces to better 'jack_lsp' work.
declare version "0.02";
declare author "jpka";
declare license "MIT";
declare description "ENOB (effective number of bits) test source using Faust and lv2";

// There are several ways to get near perfect result.

// One is to use extra randomizing sine, small but not very tiny (0.001 works well, but 0.000001 too small).

// 2nd way is to modify   '/usr/share/faust/platform.lib  tablesize = 1 << 16;' to 1 << 28 or so, which gives perfect sine with any frequency, and only one tone, but still will phase rollover (but not too often, like in order of > 1000 seconds (for 1 << 28), give enough time for noise measurement.
// Should be sum of: a) orthogonal to both sample rate and Faust sine buffer (65536), and b) some tiny amount of imperfection.

// 3rd way: note using `osci` instead of just `osc`, it is fundamentally different in terms of resulting sine noise. It eliminates requirement of use small sideway additional sine to randomize the noise. Another critical importance here is freq should be **NOT** orthogonal to both sample rate and Faust sine buffer. No alter of tablesize need.

import("stdfaust.lib");

// Quantization is not perfect at near-signal freqs (for unknown reason yet), so we lower our freq to like 100 Hz. Above ~1 kHz it is near perfect to allow set cursor at SA for noise measurements.
// Added: osci good for 18-31 bits, but for 12-20 bits, two osc's are better.
freq = 100.071;

numMaxLog = 7; // If more, can be too CPU hungry. Use 1 if 1-tone only need, to save CPU.
num = 1 << (nentry("Comb", 0, 0, numMaxLog, 1) : int);
signal = par(i, 1 << numMaxLog, os.osci(freq*(i+1)) * (i < num)) :> / (num);

bits = nentry("Bits", 16, 8, 31, 1) : int;
signBit = 1;
quant = 1.0 / (1 << (bits - signBit));
micro = 1.0 / (1024*1024); // for 20 ENOB; 1000*1000 for 60 dB

process =
// NOTE: remember, we compile with -double.

// We have 4 outputs:
// quantized one (with JACK it will have float/single precision);
// straight one (with same limitation);
// and two highly attenuated versions of both, to test SA's dynamic and ENOB scale.
// These two small signals also acts as "residue" bits. When SNR better than samples transport system offer is need, like 32-bit ('single') float limitation which have near 25 bit SNR (full scale), we add extra "residue" channel and sum both in our receiver to get extra ~20 bit resolution (using 'double' math, at least, of course).
	( signal <: (int(_ / quant + 0.5) * quant <: _ * (1 - micro), _ * micro),
				(_ <: _ * (1 - micro), _ * micro) ),

// Check points.
// * NOTE Edit .ttl required for each of these two ports: *
// From:	a lv2:OutputPort ;
//			a lv2:AudioPort ;
// To: 		a lv2:OutputPort, lv2:CVPort ;
// See https://github.com/grame-cncm/faust/discussions/1140
	( bits : vbargraph("Bits Check [CV:0]", 8, 32) ),
	( quant : ba.linear2db : vbargraph("Quant dB [CV:1]", -240, 0) )
;
