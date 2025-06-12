# enobsrc
ENOB (effective number of bits) test source using Faust and lv2

DESCRIPTION
-----------
This audio signal source emits unity single sine tone (and maybe extra sideway tiny 'noise-randomizing' 2nd sine tone), quantized with required number of bits.
Note that to take advantage of lower than ~25 bit (float) noise, it is need:
1. To compile using double precision, see Usage;
2. It is impossible with JACK directly, because JACK uses float samples. But we will provide extra "residue bits" output for synthetic tests, if your system able to sum two JACK samples flow with at least double precision.

The purpose of it is to be companion for high resolution Spectrum Analyzer, like our `jasmine-sa`, for **Effective number of bits (ENOB)** tests, by comparsion two noise floors with SA: one of from DUT (device under test, like DAC+ADC) and another from this source with variable ENOB. We get then well reproduceable ENOB measurements.

To be continued






