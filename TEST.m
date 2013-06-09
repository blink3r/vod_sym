%% FILE DI TEST PER VARIE COSE

clc
clear all

global interarrival_stream service_stream
a_c = clock;
seed1 = RandStream.create('mcg16807','Seed',5);
seed2 = RandStream.create('mcg16807','Seed',6);

tic
for i = 1:10000
    a(i) = rand;
    b(i) = rand;
end
toc


tic
for i = 1:10000
RandStream.setDefaultStream(seed1);
a = rand;
RandStream.setDefaultStream(seed2);
b = rand;

end
toc
interarrival_stream = RandStream('mcg16807','Seed',a_c(6));
service_stream = RandStream('mcg16807','Seed',a_c(5));
tic
for i = 1:10000
a= rand(seed1);
b = rand(seed2);
end
toc

tic
a = rand(seed1,10000);
b = rand(seed2,10000);
toc

tic
a = rand(10000);
b = rand(10000);
toc
% clear all
% 
% 
% event_list_2 = [];
% 
% sim_rep = 2000;
% tic;
% event_list_2 = initialize_event(event_list_2,sim_rep);
% toc
% 
% tic;
% event_list_2(1).dst = 0;
% event_list_2(1).a = 'ciao';
% event_list_2(1).b = 2;
% event_list_2(1).c = 2699;
% event_list(1).t_ist = 50;
% toc
% 
% clear all
% tic
% event_list_2.dst = 0;
% event_list_2.a = 'ciao';
% event_list_2.b = 2;
% event_list_2.c = 2699;
% event_list.t_ist = 50;
% toc
