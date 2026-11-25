% notewise: plop2's per-output idea applied to music. Each note of a melody is computed by its
% own small function from only what it needs: the key, the mode, the chord on that beat and the
% beat number. So a note can be regenerated alone, and changing one chord changes only its notes.
% Pitches are MIDI numbers; chords are scale degrees 1..7; the melody walks root, third, fifth.
%?- melody(0, major, [1,4,5,1], M).          % M = [60,69,74,60]: C major, I IV V I (C, then the third of IV, A, the fifth of V, D, and C)
%?- note(0, major, [1,4,5,1], 2, N).         % N = 74: the third note alone
%?- scale(9, minor, S).                      % A minor
%?- depends_on(2, D).                        % D = [key, mode, chord(2), beat(2)]
:- module(notewise, [scale/3, chord_tones/4, note/5, melody/4, depends_on/2, transpose/3, in_scale/3]).
:- use_module(library(lists)).
:- use_module(library(apply)).

steps(major, [0, 2, 4, 5, 7, 9, 11]).
steps(minor, [0, 2, 3, 5, 7, 8, 10]).

% scale(+Key, +Mode, -Pitches): the seven notes from middle C's octave (Key 0..11 = C..B).
scale(Key, Mode, S) :- steps(Mode, St), maplist([X, P]>>(P is 60 + Key + X), St, S0), S = S0.

% degree_pitch(+Key, +Mode, +Degree, -Pitch): degree 1..7, higher degrees go up an octave.
degree_pitch(Key, Mode, D, P) :- steps(Mode, St), I is (D - 1) mod 7, O is (D - 1) // 7, nth0(I, St, X), P is 60 + Key + X + 12 * O.

% chord_tones(+Key, +Mode, +Degree, -Tones): the triad on a degree (root, third, fifth).
chord_tones(Key, Mode, D, [R, T, F]) :- degree_pitch(Key, Mode, D, R), D3 is D + 2, degree_pitch(Key, Mode, D3, T), D5 is D + 4, degree_pitch(Key, Mode, D5, F).

% note(+Key, +Mode, +Chords, +Beat, -Pitch): beat 0, 1, 2 ... takes root, third, fifth in turn of its own chord.
note(Key, Mode, Chords, B, P) :- nth0(B, Chords, D), chord_tones(Key, Mode, D, Ts), I is B mod 3, nth0(I, Ts, P0), P = P0.

melody(Key, Mode, Chords, M) :- length(Chords, N), ( N =:= 0 -> M = [] ; Top is N - 1, numlist(0, Top, Bs), maplist([B, P]>>note(Key, Mode, Chords, B, P), Bs, M) ).

depends_on(B, [key, mode, chord(B), beat(B)]).

transpose(M, K, T) :- maplist([P, Q]>>(Q is P + K), M, T).

% in_scale(+Key, +Mode, +Pitch): the pitch's pitch class is in the key.
in_scale(Key, Mode, P) :- steps(Mode, St), X is (P - 60 - Key) mod 12, memberchk(X, St).
