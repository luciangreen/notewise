% Theorems about notewise, proved by exhaustion. Run: swipl -g main -t halt proofs/theorems.pl
:- module(theorems, [main/0]).
:- use_module('../prolog/notewise').
:- use_module(prove).
:- discontiguous theorem/1.
:- use_module(library(lists)).
:- use_module(library(apply)).
main :- prove_all(theorems).

% Domain: every key, both modes, every chord progression of length 1..3 over degrees 1..7.
key(K) :- between(0, 11, K).
mode(M) :- member(M, [major, minor]).
chords(Cs) :- between(1, 3, N), length(Cs, N), maplist([D]>>between(1, 7, D), Cs).

% 1. Every note is in the key.
theorem(notes_in_key) :- forall(( key(K), mode(M), chords(Cs), melody(K, M, Cs, Ns) ), forall(member(P, Ns), in_scale(K, M, P))).

% 2. Every note is a tone of the chord on its beat.
theorem(notes_are_chord_tones) :-
    forall(( key(K), mode(M), chords(Cs), melody(K, M, Cs, Ns), nth0(B, Ns, P) ), ( nth0(B, Cs, D), chord_tones(K, M, D, Ts), memberchk(P, Ts) )).

% 3. Note independence: changing the chord on another beat never changes this beat's note.
theorem(notes_depend_only_on_their_own_chord) :-
    forall(( member(K, [0, 7]), mode(M), chords(Cs), length(Cs, N), N >= 2, nth0(J, Cs, _), between(1, 7, D2), nth0(B, Cs, _), B \== J ),
           ( replace(J, Cs, D2, Cs2), note(K, M, Cs, B, P1), note(K, M, Cs2, B, P2), P1 == P2 )).
replace(I, L, X, L2) :- length(Pre, I), append(Pre, [_|Post], L), append(Pre, [X|Post], L2).

% 4. A note computed alone is the same as in the whole melody.
theorem(alone_equals_in_melody) :- forall(( key(K), mode(M), chords(Cs), melody(K, M, Cs, Ns), nth0(B, Ns, P) ), note(K, M, Cs, B, P)).

% 5. Changing key transposes the whole melody by the same interval.
theorem(key_change_transposes) :-
    forall(( key(K), K < 11, mode(M), chords(Cs) ), ( melody(K, M, Cs, A), K1 is K + 1, melody(K1, M, Cs, B), transpose(A, 1, B) )).
