%% some facts about president trump
age(71).
wife("Melania Trump").
son(" Donald Jr ").
son(" Eric ").
son(" Barron ").
daughter(" lvanka ").
daughter(" Tiffany ").
liveAt("white house ").
networth("3.5 billion").
hate("person"," Kim Jong un ").
hate("food", " pancake ").
like("food"," Big Mac ").
like("music"," paramore ").
like("building"," Trump tower ").
like("country", " USA ").

:- dynamic(pattern/2).

%--------------------- pattern block font -------------------------

% 1st pattern block, when user tell trump his name.
pattern(["i", "am", _, X], Response) :-
      pattern(["i", "am", X], Response).

% trump get the name of user, and let user ask questions.
pattern(["i", "am", X], Response) :-
      Response = ["President Trump: nice to meet you ", X, " ? you can ask me anything about me"].

% 2nd pattern block, when user talk about what they like to do
pattern(["i", _, "like", "to", _, "about", X], Response) :-
      pattern(["i", "like", X], Response).

pattern(["i", "like", "to", _, "about", X], Response) :-
      pattern(["i", "like", X], Response).

% basicly let user tell trump about somthing.
pattern(["i", "like", X], Response) :-
      Response = ["President Trump: I do not know  about ", X, ".", "Can you talk about another things?"].

% 3rd pattern, when user ask trump how many questions he can ask.
pattern(Input, Response) :-
      member(Term, Input),
      member(Term, [ "how"]),
      member(Term2, Input),
      member(Term2, [ "many"]),
      member(Term3, Input),
      member(Term3, [ "questions"]),
      count(A),
      X is A + 1,
      Response = ["President Trump: There are ", A ," questions you can ask ."],
      retractall(count(_)),
      assert(count(X)).

% 4th pattern, when user ask for more questions
pattern(Input, Response) :-
      member(Term2, Input),
      member(Term2, [ "more"]),
      member(Term3, Input),
      member(Term3, [ "questions"]),
      count(A),
      X is A + 2,
      retractall(count(_)),
      assert(count(X)),
      Response = ["President Trump: sure."].

% 5th pattern block, when user said yes or no, ask them why
pattern(Input, Response) :-
      member(Term, Input),
      member(Term, [ "yes"]),
      Response = ["Why so?"].

pattern(Input, Response):-
      member(Term, Input),
      member(Term, [ "no"]),
      Response = ["Why not?"].


% 6th pattern, when user finished interview.
pattern(Input, Response) :-
      member(Term, Input),
      member(Term, ["bye"]),
      Response = ["Have a good day. Bye."],
      retractall(count(_)),
      assert(count(0)).

% 7th pattern, when user ask where does trump live.
pattern(Input,Response):-
      member(Keyword1,Input),
      member(Keyword1, ["where"]),
      member(Keyword2,Input),
      member(Keyword2,["live"]),
      Response = [X],
      liveAt(X).

% 8th pattern when user ask how rich trump is
pattern(Input, Response):-
      member(Keyword1,Input),
      member(Keyword1, ["how"]),
      member(Keyword2,Input),
      member(Keyword2,["rich"]),
      Response = ["Yeah! I am rich I have $",X],
      networth(X).

% 9th pattern, when user ask trump's children
pattern(Input,Response):-
      memberAll(["how","many","children"],Input),
      Response = X,
      allChildren(X).

% 10th pattern, when user ask trump's wife.
pattern(Input,Response):-
      memberAll(["wife"],Input),
      Response = ["President Trump: my wife is ",X],
      wife(X).

% 11st pattern, when user ask trump's age.
pattern(Input,Response):-
      memberAll(["how","old","you"],Input),
      Response = ["President Trump: I'm ",X],
      age(X).

% 12nd pattern block, when user ask what trump hate and like.

% the person he hates.
pattern(Input,Response):-
      memberAll(["what","you","hate"],Input),
      nl,
      write("President Trump: which Area"),
      read(Area),
      stuffHeDislike(Area,Response).

% ask what trump likes
pattern(Input,Response):-
      memberAll(["what","you","like"], Input),
      write("President Trump: which Area"),
      nl,
      read(Area),
      stuffHeLike(Area,Response).

%-----------------------pattern block end------------------------------

%---------------------- pattern helper font----------------------------


% the stuff trump likes and dislike.
stuffHeLike(Area,Response):-
      Response = ["President Trump:",X, " is my favorite ", Area],
      like(Area,X).

stuffHeDislike(Area,Response):-
      Response = ["President Trump: I hate ",X],
      hate(Area,X).


% memberAll will find all the elements in first list if they are in the
% scond list.
memberAll([],_):-!.
memberAll(_,[]):-!.
memberAll([X|K],S):- member(X,S), memberAll(K,S).


% allChildren will get all names of children that trump has.
allChildren(L):- findall(X, (son(X);daughter(X)), L).

%---------------------- pattern helper end------------------------------


%---------------------- pat block font----------------------------------

% try match one pattern above, the cut will avoid other matching to cost
% extra time.
pat(Input,Response):-
      pattern(Input,Response),!.

% if none of pattern above matched, this means trump does not know about
% this question, so start teach mode, let user type answer for this
% question, and trump will remember it. Here, we used dynamic database.
pat(_,_):-
      count(A),
      %write("debug: pat A is "),
      %write(A),
      %nl,
      X is A + 1,
      %write("X is "),
      %write(X),
      %nl,
      retractall(count(_)),
      assert(count(X)),
      writeln("can you say your question again?"),
      read(Question),
      nl,
      writeln("can you say your answer?"),
      read(Answer),
      nl,
      string_lower(Question,Current),
      split_string(Current, " ", " ,.", S),
      write("I remember it"),
      asserta(pattern(S, ["President Trump: ",Answer])).

% ------------------------ pat block end ------------------------------


% ------------------------- utilities font -----------------------------
%print out each word of sentence.
words_to_string([]).

words_to_string([Head|Tail]) :-
      write(Head),
      words_to_string(Tail).



:- dynamic(count/1).

count(5).

% read question, match with pattern, decrease number of question that
% uesr can ask. each question will get a response.

ask(Question) :-
      pat(Question, Response),
      words_to_string(Response),
      count(NumberOfQuestion),
      check(NumberOfQuestion).

% when count reach 0, finish this interview
check(0) :-
      retractall(count(_)),
      assert(count(5)),
      nl,
      writeln('Bye').

% update current count, ask one question decrease 1.
check(A) :-
retract(count(A)),
      %write("debug: check A is "),
      %write(A),
      %nl,
      X is A - 1,
      X >= 0 ,
      nl,
      %write("debug: check X is "),
      %write(X),
      %nl,
      assert(count(X)),
      eliza_loop.

%------------------------ utilities end--------------------------------


%------------------------ Main ----------------------------------------
eliza :-
      writeln('President Trump: Hello, I am Trump. what is your name?'),
      eliza_loop.

eliza_loop :-
      write('> '),
      read(B),
      string_lower(B,Current),
      split_string(Current, " ", " ,.", S),
      ask(S).

%---------------------------------------------------------------------













