function combineFigures(savedFigure1, savedFigure2)
    % Load the saved figures
    fig1 = openfig(savedFigure1);
    fig2 = openfig(savedFigure2);
	
	numfigs_v = 2;
	
    % Create a new figure with subplots
    combfig = figure;
	clf
	set(gcf,'color','w');
	colormap jet
	set(combfig,'PaperUnits','normalized','PaperPosition',[0 0 3 2]);
	set(combfig,'units','normalized','outerposition',[0 0 2/numfigs_v 1]);
	box on

%keyboard
   % Plot the first figure
    subplot(2,1,1);
	axis off
	legend_old1 = findobj(fig1, 'Type', 'Legend');
	ax_old1 = findobj(fig1,'type','axes');
	leg_ax_1 = copyobj([legend_old1,ax_old1],combfig);
	ax1 = findobj(leg_ax_1, 'Type', 'axes');
	leg1 = findobj(leg_ax_1, 'Type', 'Legend');
	set(ax1, 'xlabel', []); % Remove x-axis label
	set(ax1, 'yLabel', []); % Remove x-axis label
	leg1.Position(1) = 0.115;
	leg1.Position(2) = 0.65;
	leg1.Position(3) = leg1.Position(3)*0.8;
    set(ax1, 'XTickLabel', []); % Remove x-axis labels
	ax1.Position(2) = 0.60; % Set position to go from 0.5 to 1 vertically
	ax1.Position(4) = 0.35; % Reduce height of the first subplot
	
    % Plot the second figure
    subplot(2,1,2);
    ax2 = gca;
    copyAxesProperties(ax2, fig2);
    copyobj(allchild(get(fig2,'CurrentAxes')), ax2);
	ax2.Position(2) = 0.25; % Set position to go from 0 to 0.5 vertically
	% Remove the first y-axis tick label
    ax2_yt= get(ax2, 'YTick');
    ax2_yt = ax2_yt(1:end-1);
    set(ax2, 'YTick', ax2_yt);
    ax2.Position(4) = 0.35; % Increase height of the second subplot	
	

	ax1.Position(1) = 0.10; 
	ax2.Position(1) = 0.10;
	ax1.Position(3) = ax2.Position(3);
	
	xlabel('Wavelength (\AA)', 'Interpreter', 'latex');

	% Set y-axis label
	ylab = ylabel('Polarization (%)', 'Interpreter', 'latex');
	ylab.Position(2) = 1.5
	ylab.Position(1) = 600
	
    % Optionally, you can close the loaded figures
    close(fig1);
    close(fig2);
	
	filename = [fileparts(savedFigure1), '\combinedfig_vert.eps']
	
	saveas(combfig, [filename], 'epsc');
	eval(['!epstopdf ' filename]);

	close(combfig)

end