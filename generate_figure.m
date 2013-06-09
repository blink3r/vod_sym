%% Figure Generator with Format
% =========================================================================

function[] = generate_figure(x,y,x1,y2,x3,y3,x4,y4) 

% =========================================================================
% Specify Dimensions and Position on Screen
% =========================================================================
% -------------------------------------------------------------------------
% Figure Dimensions
% -------------------------------------------------------------------------

% For Normal Figures
height=(1.0/1.618); % width/golden ratio
width=1;

% For Wide Figures
%height=1.0/1.618; % width/golden ratio
%width=2;

scale=700; % 3.13 inches
% -------------------------------------------------------------------------
% Figure Position on Screen
% -------------------------------------------------------------------------
xpos=50;
ypos=500;

% =========================================================================
% Define Functions to be Plotted
% =========================================================================
x=0:.01:2*pi;
f1=cos(x);
f2=sin(x);

% =========================================================================
% Generate Figure
% =========================================================================
% -------------------------------------------------------------------------
% Figure Properties
% -------------------------------------------------------------------------
figure; % Create Figure
axes('FontName','Times New Roman') % Set axis font style
box('on'); % Define box around whole figure
set(gcf,'Position',[xpos ypos scale*width scale*height]) % Set figure format

% -------------------------------------------------------------------------
% Plot Data
% -------------------------------------------------------------------------
hold on
plot1=plot(x,f1);
plot2=plot(x,f2);

% -------------------------------------------------------------------------
% Plot Properties
% -------------------------------------------------------------------------
set(plot1,'LineWidth',1,'LineStyle','-');
set(plot2,'LineWidth',1,'LineStyle','--');

% Set Axis Limits
xlim([min(x), max(x)])
ylim([min(f1), max(f1)])

% Create xlabel
xlabel('\xi','FontSize',11,'FontName','Times New Roman','FontAngle','italic');
% xlabel('$\xi$','FontSize',11,'FontName','Times New Roman','interpreter','LaTex','rot',0);

% Create ylabel
ylabel('\eta','FontSize',11,'FontName','Times New Roman','FontAngle','italic','rot',0);
% ylabel('$\eta$','FontSize',11,'FontName','Times New Roman','interpreter','LaTex','rot',0);

% Create Legend
hleg1 = legend('$\cos(x)$','$\sin(x)$');

% Set Legend Properties
set(hleg1,'Interpreter','latex')
set(hleg1,'Location','SouthWest')
set(hleg1,'box','on')

% =========================================================================
% Export Figure
% =========================================================================
fig = gcf;
style = hgexport('factorystyle');
style.Bounds = 'loose';
hgexport(fig,'Example_Figure.eps',style,'applystyle', true);
drawnow;

print -depsc2 -tiff myfile.eps

end
