# notewise

plop2's per-output idea applied to music. Each note of a melody is computed by its own small function from only what it needs: the key, the mode, the chord on that beat and the beat number. So a note can be regenerated alone, and changing one chord changes only its notes. Pitches are MIDI numbers; chords are scale degrees 1..7; the melody walks root, third, fifth.

## Use

```prolog
?- use_module(prolog/notewise).
?- melody(0, major, [1,4,5,1], M).          % M = [60,69,74,60]: C major, I IV V I (C, then the third of IV, A, the fifth of V, D, and C)
?- note(0, major, [1,4,5,1], 2, N).         % N = 74: the third note alone
?- scale(9, minor, S).                      % A minor
?- depends_on(2, D).                        % D = [key, mode, chord(2), beat(2)]
```

## Proofs

`proofs/theorems.pl` proves 5 theorems by exhaustion: each one is checked for every case in a finite domain that covers every branch of the definitions. every key, both modes, every chord progression of length 1..3 over degrees 1..7.

1. Every note is in the key.
2. Every note is a tone of the chord on its beat.
3. Note independence: changing the chord on another beat never changes this beat's note.
4. A note computed alone is the same as in the whole melody.
5. Changing key transposes the whole melody by the same interval.

```sh
swipl -g main -t halt proofs/theorems.pl
```

## 200 inputs and outputs

`io/ios.txt` lists 200 inputs and outputs from real runs, and `io/ios.pl` has the same as Prolog facts. The inputs come from a fixed seed (`io/cases.pl`). `swipl -g check -t halt io/run.pl` runs them again. It fails if any output changes, or if a predicate doesn't confirm its own recorded output, which checks steadfastness. GitHub Actions runs the proofs and the examples on every push, and records the examples on the first push.

Licence: BSD-3-Clause.
