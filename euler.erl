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
% Problem 10 in project euler.
problem10() ->
	io:format("Find the sum of all the primes below two million.~n"),
	L = [X || X <- lists:seq(1, 2000000), is_prime(X)],
	lists:sum(L).

is_prime(1) ->
	false;
is_prime(2) ->
	true;
is_prime(3) ->
	true;
is_prime(X) when X rem 2 == 0 ->
	false;
%is_prime(X) when is_integer(math:sqrt(X)) ->
%	false;
is_prime(X) ->
	Divisors = lists:seq(2, erlang:trunc(math:sqrt(X))),
	case [A || A <- Divisors, X rem A == 0] of
		[] ->
			true;
		_any ->
			false
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