-module(euler).
-compile([export_all]).

%-----------------------------------------------------------------------------------------------
% Permutations puzzle. Not from project euler. Prepare permutations of a list.
% E.g.: perms([a,b,c]) -> [{a,b,c}, {a,c,b}, ..., {c,b,a}]
perms([]) ->
 	[[]];
perms(L) ->
	[ [H|T] || H <- L, T <- perms(L-- [H])].


%-----------------------------------------------------------------------------------------------
% Problem 3

problem3() ->
	largest_prime_factor(600851475143).

%  See: http://www.mathblog.dk/project-euler-problem-3/
largest_prime_factor(N) ->
	largest_prime_factor(N, 2, 0).

largest_prime_factor(N, Current, LargestFactor) when Current*Current =< N ->
	case N rem Current == 0 of
		true -> largest_prime_factor(N div Current, Current, Current);
		false ->
			Current1 = case Current of %Optimize: skip even numbers after we've checked 2.
				2 -> 3;
				_ -> Current + 2
			end,
			largest_prime_factor(N, Current1, LargestFactor)
	end;
largest_prime_factor(N, Current, _LargestFactor) when N > Current ->
	{n, N, current, Current, largest_factor, N};
largest_prime_factor(N, Current, LargestFactor) ->
	{n, N, current, Current, largest_factor, LargestFactor}.

%-----------------------------------------------------------------------------------------------
% Problem 10 in project euler.
problem10() ->
	io:format("Find the sum of all the primes below two million.~n"),
	L = [X || X <- lists:seq(1, 2000000), is_prime(X)],
	lists:sum(L).

is_prime(1) -> false;
is_prime(2) -> true;
is_prime(3) -> true;
is_prime(X) when X < 0 -> is_prime(abs(X));
is_prime(X) when X rem 2 == 0 -> false;
is_prime(X) ->
	Divisors = lists:seq(2, erlang:trunc(math:sqrt(X))),
	case [A || A <- Divisors, X rem A == 0] of
		[] ->
			true;
		_any ->
			false
	end.

%-----------------------------------------------------------------------------------------------
% Problem 12
% The sequence of triangle numbers is generated by adding the natural numbers. So the 7th triangle
% number would be 1 + 2 + 3 + 4 + 5 + 6 + 7 = 28. The first ten terms would be:
%	1, 3, 6, 10, 15, 21, 28, 36, 45, 55, ...
% Find the first triangle number with greater than 500 divisors.
%  NOTE: this solution is quite slow! Be prepared to wait for a while.
problem12() ->
	problem12(1, 1).

problem12(N, Sum) ->
	%io:format("N ~p Triangle Number ~p ~n", [N, Sum]),
	NumDivisors = num_divisors(Sum),
	case NumDivisors > 500 of
		true ->
			{triangle_number, Sum, number_of_divisors, NumDivisors};
		false ->
			problem12(N+1, Sum+N+1)
	end.

proper_divisors(N) ->
	divisors(1, N, []).

% A naive (brute-force) method of finding all the divisors of an integer.
divisors(N) ->
	divisors(1, N, [N]).

divisors(D, N, Divisors) when D >= (N div 2) + 1 ->
	lists:sort(Divisors);
divisors(D, N, Divisors) ->
	case (N rem D) == 0 of
		true ->
			divisors(D+1, N, [D|Divisors]);
		false ->
			divisors(D+1, N, Divisors)
	end.

% A naive (brute-force) method of counting the number of divisors of an integer.
num_divisors(N) ->
	num_divisors(1, N, 1).

num_divisors(D, N, NumDivisors) when D >= (N div 2) + 1 ->
	NumDivisors;
num_divisors(D, N, NumDivisors) ->
	case (N rem D) == 0 of
		true ->
			num_divisors(D+1, N, NumDivisors+1);
		false ->
			num_divisors(D+1, N, NumDivisors)
	end.

%-----------------------------------------------------------------------------------------------
% Problem 13 in project euler.
problem13() ->
	%Read in list of 50-digit numbers (there are 100 of them)
	{ok, [Numbers]} = file:consult("problem13.data.txt"),
	lists:sum(Numbers).

%-----------------------------------------------------------------------------------------------
% Problem 14 in project euler
%  Find the starting number (under 1 million) that produces the longest chain. The solution is:
%		> test:longest_collatz().
%		{longest_chain,525,generated_by_starting_int,837799}
problem14() ->
	longest_collatz(2, 1, 1).

longest_collatz(1000000, Max, NMax) ->
	{longest_chain, Max, generated_by_starting_int, NMax};
longest_collatz(N, Max, NMax) ->
	Length = length(collatz(N)),
	% Case expression has been refactored into a method below.
	% case Length > Max of
	% 	true ->
	% 		longest_collatz(N+1, Length, N);
	% 	false ->
	% 		longest_collatz(N+1, Max, NMax)
	% end.
	longest_collatz(Length, N, Max, NMax).

longest_collatz(Length, N, Max, _NMax) when Length > Max ->
	longest_collatz(N+1, Length, N);
longest_collatz(Length, N, Max, NMax) when Length =< Max ->
	longest_collatz(N+1, Max, NMax).

% Generate a collatz sequence for the integer N
collatz(N) ->
	collatz_int(N, []).

collatz_int(N, L) when N =< 1 ->
	lists:reverse([N|L]);
collatz_int(N, L) when N rem 2 == 0 ->
	collatz_int(erlang:trunc(N/2), [N|L]);
collatz_int(N, L) when N rem 2 =/= 0 ->
	collatz_int(erlang:trunc(3*N + 1), [N|L]).

%-----------------------------------------------------------------------------------------------
% Problem 15 in project euler.
% This is a combinatorial problem based on the paths through the NxN grid. All paths have length
%  2N and consist of N 'Rights' and N 'Downs'. Thus, choosing the ways to arrange the paths we  have:
%
%				2n(2n-1)(2n-2)..(2n-n+1)	(2n)!
%		2nCn = ------------------------- = --------
%				n(n-1)(n-2)...1 			(n!)^2
%
% Note that 2nCn means "2n Choose n".
problem15() ->
	problem15(20).

problem15(GridSize) ->
	Numerator = factorial(2*GridSize),
	Denominator = factorial(GridSize),
	Numerator div (Denominator * Denominator).


%-----------------------------------------------------------------------------------------------
% Problem 18: Erlang is a really bad platform for this problem. It's not worth the trouble.
%  Good explanation of an efficient bottom-up algorithm: http://www.mathblog.dk/project-euler-18/
problem18() -> 1074.

%-----------------------------------------------------------------------------------------------
% Problem 21.
problem21() ->
	AmicableNumbers = [],
	problem21(AmicableNumbers, 1).

problem21(AmicableNumbers, 10000) ->
	{solution, lists:sum(AmicableNumbers), numbers, AmicableNumbers};
problem21(AmicableNumbers, Current) ->
	Sum = sum_divisors(Current),	
	case (Current /= Sum) andalso (Current == sum_divisors(Sum)) of
		true ->
			problem21([Current|AmicableNumbers], Current + 1);
		false ->
			problem21(AmicableNumbers, Current + 1)
	end.

sum_divisors(N) ->
	lists:sum(proper_divisors(N)).

%-----------------------------------------------------------------------------------------------
% Problem 22
problem22() ->
	{ok, [Names]} = file:consult("problem22.data.txt"),
	Sorted = lists:sort(Names),
	{_, TotalScore} = lists:foldl(fun(Name, {Index, Sum}) -> 
									{Index + 1, Sum + (Index * name_score(Name))}
								  end, {1, 0}, Sorted),
	TotalScore.

name_score(Name) ->
	name_score(Name, 0).

name_score([], Score) ->
	Score;
name_score([H|T], Score) ->
	name_score(T, Score + H - 64).


%-----------------------------------------------------------------------------------------------
% Problem 23
% We have to precompute the cache or else the solution is VERY slow. Doing it this way takes a few seconds.
problem23() ->
	% 20161 is a well-known upper bound for this problem.
	AbundantInts = [{X, 0} || X <- lists:seq(1, 20161), is_abundant(X)],
	Dict = dict:from_list(AbundantInts),
	Ints = [X || X <- lists:seq(1, 20161), is_sum_of_abundants_cache(X, Dict) == false],
	lists:sum(Ints).

is_abundant(N) -> is_abundant(N, lists:sum(proper_divisors(N))).

is_abundant(N, SumOfDivisors) when SumOfDivisors > N -> true;
is_abundant(N, SumOfDivisors) when SumOfDivisors =< N -> false.

is_sum_of_abundants(N) when N > 28123 -> true; % All numbers larger than 28123  are the sum of two abundant numbers.
is_sum_of_abundants(N) when N < 24 -> false; % 24 is the smallest number that can be written as the sum of two abundant numbers.
is_sum_of_abundants(N) -> is_sum_of_abundants(1, N-1).

is_sum_of_abundants(Lower, Upper) when Lower > Upper -> false;
is_sum_of_abundants(Lower, Upper) when Lower =< Upper ->
	case is_abundant(Lower) andalso is_abundant(Upper) of
		true -> true;
		false -> is_sum_of_abundants(Lower + 1, Upper - 1)
	end.

% This version looks for numbers in a cache to improve performance
is_sum_of_abundants_cache(N, _Dict) when N > 28123 -> true; % All numbers larger than 28123  are the sum of two abundant numbers.
is_sum_of_abundants_cache(N, _Dict) when N < 24 -> false; % 24 is the smallest number that can be written as the sum of two abundant numbers.
is_sum_of_abundants_cache(N, Dict) -> is_sum_of_abundants_cache(1, N-1, Dict).

is_sum_of_abundants_cache(Lower, Upper, _Dict) when Lower > Upper -> false;
is_sum_of_abundants_cache(Lower, Upper, Dict) when Lower =< Upper ->
	case dict:is_key(Lower, Dict) andalso dict:is_key(Upper, Dict) of
		true -> true;
		false -> is_sum_of_abundants_cache(Lower + 1, Upper - 1, Dict)
	end.

%-----------------------------------------------------------------------------------------------
% Problem 24.
% Find the millionth permutation of the digits 0,1,2,3,4,5,6,7,8,9
% (I thought this would take forever, but it runs in about 2-3 seconds!)
problem24() ->
	L = perms([0,1,2,3,4,5,6,7,8,9]),
	lists:nth(1000000, L).


%-----------------------------------------------------------------------------------------------
% Problem 25.

problem25() ->
	% Quick testing suggests that we're looking for a number x, such that 4000 < x < 5000 because:
	%  fib(4000) -> length 836
	%  fib(5000) -> length 1045
	problem25(4000).

problem25(N) ->
	case length(integer_to_list(fib(N))) >= 1000 of
		true -> N;
		false -> problem25(N+1)
	end.

% SLOW for large N (greater than about 25).
% fib(1) -> 1;
% fib(2) -> 1;
% fib(N) -> fib(N-1) + fib(N-2).

% This is a fast implementation of fib. Works instantly for values of N > 1000!
% Even fib(100000) takes only about 1 second!
fib(1) -> 1;
fib(2) -> 1;
fib(N) -> fib(3, N, [1,1]).
fib(X, N, [H|_]) when X > N ->
	H;
fib(X, N, L = [H1|[H2|_T]]) ->
	fib(X + 1, N, [H1+H2 | L]).

%-----------------------------------------------------------------------------------------------
% Problem 27
problem27() -> 
	{MaxA, MaxB, MaxPrimes} = problem27(-1000, -1000, 0, 0, 0),
	{a, MaxA, b, MaxB, numprimes, MaxPrimes, prod, MaxA * MaxB}.

problem27(A, B, MaxA, MaxB, MaxPrimes) when A == 1001, B == 1001 ->
	{MaxA, MaxB, MaxPrimes};	
problem27(A, B, MaxA, MaxB, MaxPrimes) when B == 1001 ->
	problem27(A+1, -1000, MaxA, MaxB, MaxPrimes);
problem27(A, B, MaxA, MaxB, MaxPrimes) ->
	Poly = generate_poly(A, B),
	NumPrimes = num_consecutive_primes(Poly),
	case NumPrimes > MaxPrimes of
		true -> problem27(A, B+1, A, B, NumPrimes);
		false -> problem27(A, B+1, MaxA, MaxB, MaxPrimes)
	end.

generate_poly(A,B) -> 
	fun(N) -> N*N + A*N + B end.

num_consecutive_primes(Poly) -> num_consecutive_primes(Poly, 0, 0).
num_consecutive_primes(Poly, N, NumConsecutive) ->
	X = Poly(N),
	case is_prime(X) of
		true -> num_consecutive_primes(Poly, N+1, NumConsecutive+1);
		false -> NumConsecutive
	end.

%-----------------------------------------------------------------------------------------------
% Problem 29.  This is very similar to the perms example up top ^^^.
problem29() ->
	Items = [erlang:trunc(math:pow(A, B)) || A <- lists:seq(2,100), B <- lists:seq(2,100)],
	Result = lists:usort(Items), %Deduplicate the list.
	{num_items, length(Result), items, Result}.

%-----------------------------------------------------------------------------------------------
% Problem 30
problem30() ->
	LowerBound = 2,
	UpperBound = 1000000, %Come up with a good upper bound...
	Nums = [X || X <- lists:seq(LowerBound, UpperBound), X == sum_of_digits_powers(X, 5)],
	Nums2 = Nums -- [1], %Question states that 1 doesn't count as it's not a sum.
	{sum, lists:sum(Nums2), nums, Nums2}.

sum_of_digits_powers(N, Power) ->
	sum_of_digits_powers(integer_to_list(N), Power, 0).

sum_of_digits_powers([], _Power, Sum) -> trunc(Sum);
sum_of_digits_powers([H|T], Power, Sum) ->
	{Int, []} = string:to_integer([H]),
	sum_of_digits_powers(T, Power, Sum + math:pow(Int, Power)).

%-----------------------------------------------------------------------------------------------
% Problem 34 in project euler
% Find the sum of all the numbers which are equal to their factorial sum.
% The really tricky part in this one is determining an upper bound (seems like 50,000 is reasonable).
% Here is an upper bound suggestion from the forum:
%	9!=362880
%	9999999 is an easy upper limit to come up with. 7 times 9! is less than 9999999.
% See http://mathworld.wolfram.com/Factorion.html
% There are exactly four such numbers, and since we're adding the digit factorials, the factorion
% of an N-digit number cannot exceed N*9!.
problem34() ->	
	L = [N || N <- lists:seq(1, 50000), N == factorial_sum(N)],
	L2 = lists:filter(fun(X) -> X > 2 end, L), %% 1! and 2! are excluded as they are not sums!
	Sum = lists:sum(L2),
	{final_sum, Sum, numbers, L2}.

factorial_sum_equal(N) ->
	N =:= factorial_sum(N).

% Add the factorials of the digits of N. Eg, suppose N = 145:
% factorial sum is 1! + 4! + 5! = 1 + 24 + 120 = 145.
factorial_sum(N) ->
	factorial_sum(integer_to_list(N), 0).

factorial_sum([], Sum) -> Sum;
factorial_sum([Digit|Rest], Sum) ->
	{N, _} = string:to_integer([Digit]),
	factorial_sum(Rest, Sum + factorial(N)).

factorial(0) ->	1;
factorial(1) -> 1;
factorial(N) ->
	N * factorial(N-1).

%-----------------------------------------------------------------------------------------------
% TESTS
-include_lib("eunit/include/eunit.hrl").

factorial_test() ->
	?assertEqual(1, factorial(0)),
	?assertEqual(1, factorial(1)),
	?assertEqual(2, factorial(2)),
	?assertEqual(6, factorial(3)),
	?assertEqual(24, factorial(4)),
	?assertEqual(120, factorial(5)),
	?assertEqual(720, factorial(6)).

factorial_sum_test() ->
	?assertEqual(145, factorial_sum(145)).
	
factorial_sum_equal_test() ->
	?assertEqual(true, factorial_sum_equal(145)),
	?assertEqual(false, factorial_sum_equal(120)).

is_prime_test() ->
	?assertEqual(true, is_prime(-3)),
	?assertEqual(false, is_prime(1)),
	?assertEqual(true, is_prime(2)),
	?assertEqual(true, is_prime(3)),
	?assertEqual(false, is_prime(4)),
	?assertEqual(true, is_prime(5)),
	?assertEqual(false, is_prime(6)),
	?assertEqual(true, is_prime(7)),
	?assertEqual(false, is_prime(8)),
	?assertEqual(false, is_prime(9)),
	?assertEqual(false, is_prime(10)),
	?assertEqual(true, is_prime(23)),
	?assertEqual(false, is_prime(50)),
	?assertEqual(true, is_prime(71)),
	?assertEqual(false, is_prime(100)).

divisors_test() ->
	?assertEqual([1], divisors(1)),
	?assertEqual([1,2], divisors(2)),
	?assertEqual([1,3], divisors(3)),
	?assertEqual([1,2,4], divisors(4)),
	?assertEqual([1,5], divisors(5)),
	?assertEqual([1,2,3,6], divisors(6)),
	?assertEqual([1,2,4,7,14,28], divisors(28)).

proper_divisors() ->
	?assertEqual([1,2,4,7,14], proper_divisors(28)).

num_divisors_test() ->
	?assertEqual(length([1]), num_divisors(1)),
	?assertEqual(length([1,2]), num_divisors(2)),
	?assertEqual(length([1,3]), num_divisors(3)),
	?assertEqual(length([1,2,4]), num_divisors(4)),
	?assertEqual(length([1,5]), num_divisors(5)),
	?assertEqual(length([1,2,3,6]), num_divisors(6)),
	?assertEqual(length([1,2,4,7,14,28]), num_divisors(28)).

problem15_test() ->
	?assertEqual(2, problem15(1)),
	?assertEqual(6, problem15(2)).

% problem18_load_rows_test() ->
% 	{ok, Rows} = file:consult("problem18.data.txt"),
% 	Dict = load_rows(Rows),
% 	?assertEqual(75, dict:fetch({1, 1}, Dict)),
% 	?assertEqual(47, dict:fetch({3, 2}, Dict)),
% 	?assertEqual(80, dict:fetch({9, 7}, Dict)).

sum_divisors_test() ->
	?assertEqual(284, sum_divisors(220)),
	?assertEqual(220, sum_divisors(284)).

name_score_test() ->
	?assertEqual(53, name_score("COLIN")).

largest_prime_factor_test() ->
	{_, _, _, _, _, LargestFactor} = largest_prime_factor(13195),
	?assertEqual(29, LargestFactor).


is_abundant_test() ->
	?assertEqual(false, is_abundant(1)),
	?assertEqual(false, is_abundant(2)),
	?assertEqual(false, is_abundant(3)),
	?assertEqual(false, is_abundant(4)),
	?assertEqual(false, is_abundant(5)),
	?assertEqual(false, is_abundant(6)),
	?assertEqual(false, is_abundant(7)),
	?assertEqual(false, is_abundant(8)),
	?assertEqual(false, is_abundant(9)),
	?assertEqual(false, is_abundant(10)),
	?assertEqual(false, is_abundant(11)),
	?assertEqual(true, is_abundant(12)),
	?assertEqual(false, is_abundant(13)).


is_sum_of_abundants_test() ->
	?assertEqual(false, is_sum_of_abundants(23)),
	?assertEqual(true, is_sum_of_abundants(24)),
	?assertEqual(false, is_sum_of_abundants(25)).

fib_test() ->
	?assertEqual(1, fib(1)),
	?assertEqual(1, fib(2)),
	?assertEqual(2, fib(3)),
	?assertEqual(3, fib(4)),
	?assertEqual(5, fib(5)),
	?assertEqual(8, fib(6)),
	?assertEqual(13, fib(7)),
	?assertEqual(21, fib(8)),
	?assertEqual(34, fib(9)),
	?assertEqual(55, fib(10)),
	?assertEqual(89, fib(11)),
	?assertEqual(144, fib(12)).

generate_poly_test() ->
	% Produce the equation n^2 + 3n + 7
	Poly = generate_poly(3, 7),
	?assertEqual(47, Poly(5)).

num_consecutive_primes_test() ->
	Poly = generate_poly(1, 41),
	NumPrimes = num_consecutive_primes(Poly),
	?assertEqual(40, NumPrimes),
	Poly2 = generate_poly(-79, 1601),
	NumPrimes2 = num_consecutive_primes(Poly2),
	?assertEqual(80, NumPrimes2).


sum_of_digits_powers_test() ->
	?assertEqual(1634, sum_of_digits_powers(1634, 4)),
	?assertEqual(8208, sum_of_digits_powers(8208, 4)),
	?assertEqual(9474, sum_of_digits_powers(9474, 4)).