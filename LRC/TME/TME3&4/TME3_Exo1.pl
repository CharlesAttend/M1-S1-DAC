r(a,b).
r(f(X), Y) :- p(X,Y).
p(f(X), Y) :- r(X,Y).