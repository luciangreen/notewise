:- module(cases, [title/1, case/3]).
:- use_module('../prolog/notewise').
:- use_module(engine).
title('notewise').
chords_g(Cs) :- rnd_int(1, 8, N), length(Cs, N), maplist([D]>>rnd_pick([1, 4, 5, 6, 2, 3, 7, 1, 5], D), Cs).
case(melody, [K, M, Cs], melody) :- rnd_int(0, 11, K), rnd_pick([major, minor], M), chords_g(Cs).
case(note, [K, M, Cs, B], note) :- rnd_int(0, 11, K), rnd_pick([major, minor], M), chords_g(Cs), length(Cs, N), Top is N - 1, rnd_int(0, Top, B).
case(chord_tones, [K, M, D], chord_tones) :- rnd_int(0, 11, K), rnd_pick([major, minor], M), rnd_int(1, 7, D).
case(scale, [K, M], scale) :- rnd_int(0, 11, K), rnd_pick([major, minor], M).
