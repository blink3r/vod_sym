function [Pq, U, EN, ET, EW, EWd, ENQ, systemUtilization]=MMm(lambda,mu,m)
%***********************************************************************************
% Author:  Eric Humenay, ebh5n@cs.virginia.edu; Xiuduan Fang, xf4c@virginia.edu; 
% Date: Nov 20, 2006
%
% MMm.m calculates the probability of an arriving job finding that all m server are busy, per-server utilizatioin,
% mean number of customer in the system, mean response time, mean waiting time for all customers, 
% mean waiting time for delayed customers, and mean number of customers in queue in an MMm system.
%
% Inputs:
%   lambda: call arrival rate; larger than 0
%   mu: service rate per server; larger than 0
%   m: the number of servers; an positive integer 
% Outputs:
%   Pq: the probability of an arriving job finding that all m servers are
%   busy
%   U: per-server utilization
%   EN: mean number of customer in the system
%   ET: mean response time 
%   EW: mean waiting time for all customers, 
%   EWd: mean waiting time for delayed customers 
%   ENQ: mean number of customers in queue
%   systemUtilization
% The direct numerical calculation of of Erlange-B formula is not very appropriate
% since both n! and rho^n increase quickly so that overflow in the computer
% will occur. Instead, we should use recursion formula
% see page 223 in http://oldwww.com.dtu.dk/teletraffic/handbook/telenookpdf.pdf

% In the lecture note of MMm, load = lambda/(m*mu). The recursion formula
% in the above reference use load = lambda/mu. To distinuge these two
% different load, we set perserverload = lambda/(m*mu) and systemload =
% lambda/mu.
%***********************************************************************************
if lambda<=0
    fprintf ('Syntax: MMm(lambda,mu,m)');
    error ('Bad parameter: load shoud be greater than 0 ');
elseif mu<=0
    fprintf ('Syntax: MMm(lambda,mu,m)');
    error ('Bad parameter: mu shoud be greater than 0 ');
elseif (m~=ceil(m)) || (m<=0) || lambda>=m*mu
    fprintf ('Syntax: erlangb(load,m)');
    error ('Bad parameter: m should be a positive integer and lambda/(m*mu) should be smaller than 1');
end

perserverload = lambda/(m*mu);
systemload = lambda/mu;

% use equ(12.9) on page 223 to compute Pq
%function [Pb, U]=erlangb(load,m)
[Pb_temp, U_temp]=erlangb(systemload,m);
Pq = Pb_temp/(1-perserverload*(1-Pb_temp));

U = perserverload;
systemUtilization = m*U;

ENQ = Pq*perserverload/(1-perserverload);
EW = ENQ/lambda;
EWd = perserverload/(lambda*(1-perserverload));
ET = EW + 1/mu;
EN = ET*lambda;
