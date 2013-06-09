function[duration_pdf] = build_duration_pdf
% This function create the distribution of the duration of video files for
% hour video stream system.
% TO-DO: create a variable to le the function build differents distribution
% for different "server-type" (more long files, more short files)

X = 50:10e3;

y1 = normpdf(X,0,600);
y2 = normpdf(X,2000,400);
y3 = normpdf(X,3300,600);
y4 = normpdf(X,5821,1223);

y = 0.63.*y1 + 0.1.*y2 + 0.18.*y3 +0.09.*y4;

duration_pdf = y;

end


