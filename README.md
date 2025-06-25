# enobsrc
ENOB (effective number of bits) test source using Faust and lv2

DESCRIPTION
-----------
_Please read and understand exactly the purpose of ANSI C code at [1]:p.22._

This audio signal source emits unity single sine tone (and maybe extra sideway tiny 'noise-randomizing' 2nd sine tone), quantized with required number of bits.
Note that to take advantage of lower than ~25 bit (float) noise, it is need:
1. To compile using double precision, see Usage;
2. It is impossible with JACK directly, because JACK uses float samples. But we will provide extra "residue bits" output for synthetic tests, if your system able to sum two JACK samples flow with at least double precision.

The purpose of this test source is to be companion for high resolution Spectrum Analyzer, like our <tt>[jasmine-sa](https://github.com/twonoise/jasmine-sa),</tt> for **Effective number of bits (ENOB)** tests, by comparsion two noise floors with SA: 
* one of from DUT (device under test, like DAC+ADC),
* and another one (or several) from this source(s) with variable ENOB.
  
We get then well reproduceable ENOB measurements.

To be continued

Known Bugs
----------
* There is no _**output** CV port_ for lv2 plugins (i.e., `faust2lv2`) support currently. One need to [manually update](https://github.com/twonoise/enobsrc/blob/19a64f5b5cb59c116e66a3cdc77178235e5896aa/enobsrc.dsp#L41) generated `.ttl` file.
See https://github.com/grame-cncm/faust/discussions/1140
* There is no input _**integer** sliders_ support currently. Again, one need to [manually update](https://github.com/twonoise/enobsrc/blob/19a64f5b5cb59c116e66a3cdc77178235e5896aa/enobsrc.dsp#L22) generated `.ttl` file after compile. <br>
I was told on chat that refactoring of Faust is planned, so we may obtain integers soon, so i am do not report this issue currently.
* Port naming is not work (for `faust2lv2`, at least) or i can't figure out how to do that. So all our ports are named `outX`, include these we named `Bits Check`, `Quant dB`, until one rename it at `.ttl` file manually. See [this issue](https://github.com/grame-cncm/faust/issues/435).

CREDITS
-------
[1] https://holometer.fnal.gov/GH_FFT.pdf



