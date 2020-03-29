function plotar(a_value, q_value, handles, salvar)
% função para plotar região de estabilidade e nyquist de acordo com os
% valores de 'a' e 'Q'

    GUI1        = findobj(allchild(groot), 'flat', 'Tag', 'fig_main');
    handlesGUI1 = guidata(GUI1);

    a = a_value; 
    q = q_value; 
    
    % pegar dados dos outros callbacks
    NyquistData = getappdata(handlesGUI1.fig_main, 'NyquistData');
    re = NyquistData.real;
    im = NyquistData.imag;
    freq = NyquistData.freq;

    % definição limites do plot
    lim_x = get(handles.plot_estabilidade, 'XLim');
    lim_y = get(handles.plot_estabilidade, 'YLim');
    r = min(lim_x(1), lim_y(1)):0.01:max(lim_x(2), lim_y(2));
    [X, Y] = meshgrid(r);

    % região de estabilidade
    a = real(a);
    q = abs(q)^2;
    cond1 = inequacao(a, q, X, Y);
    cond1 = double(cond1);	
    cond1(cond1 == 0) = NaN;
    
    % rotina para descobrir até onde plotar nyquist da ft
    re_stable = [re(1)];
    im_stable = [im(1)];
    last_w = [freq(1)];
    for i = 2:1:length(freq)
        cond = inequacao(a, q, re(i), im(i));
        if cond
            re_stable(i) = re(i);
            im_stable(i) = im(i);
            last_w(i) = freq(i);
        else   
            break
        end    
    end    

    axes(handles.plot_estabilidade);
    % plot dominio de estabilidade
    surf(X, Y, cond1, 'FaceAlpha', 0.3, 'EdgeColor', 'none'); 
    hold on;
    view(0, 90);
    % plot linha dos eixos
    plot([-10*abs(lim_x(1)), 10*lim_x(2)],[0 0],'k:');
    plot([0 0],[-10*abs(lim_y(1)), 10*lim_y(2)],'k:');
    % plot nyquist de fundo
    plot(re, im, re, -im, 'color', [0.55 0.55 0.55], 'LineWidth', 1.5);
    % plot nyquist de acordo com a frequência
    plot(re_stable, im_stable, 'r', re_stable, -im_stable, 'r', 'LineWidth', 1.5);
    plot(re_stable(i-1), im_stable(i-1), 'or', re_stable(i-1), -im_stable(i-1), 'or', 'LineWidth', 1.5);
    % plot inicio nyquist
	plot(re(1), im(1), 'kx', 'LineWidth', 2);
    hold off;
    grid on;
    % configurações plot
    set(handles.plot_estabilidade, 'XLim', [lim_x(1), lim_x(2)], 'YLim', [lim_y(1), lim_y(2)]);
    xlabel('Real Axis');
    ylabel('Imaginary Axis');
    % textos
    if last_w(end) == freq(end)
        str_estabilidade = 'Stable';
    else
        str_estabilidade = 'Instable';
    end 
    freq_est = num2str(round(last_w(end)*0.1592,2));
    set(handles.edit_freq, 'string', freq_est);
    set(handles.edit_estabilidade, 'string', strcat(str_estabilidade, ' Loop'));
    % texto plot inicio nyquist
    text(lim_x(1)+0.4, lim_y(1)+1, 'x (\omega = 0)', 'FontSize', 11, 'HorizontalAlignment','left');
    
    % rotina para salvar print do gráfico
    if salvar
        mainfig = gcf;
        
        GUI = findobj(allchild(groot), 'flat', 'Tag', 'fig_controlador');
        handless = guidata(GUI);
                
        ImageDPI = 800;
        ImageSizeX = 7;
        ImageSizeY = 7;
        freq_est(freq_est=='.') = '_';
        FileLabel = [strcat('Freq_', freq_est, '_', str_estabilidade)]; 
        location = get(handless.edit_save, 'string');
        if ~strcmp(location(end), '\')
            location = strcat(location, '\');
        end   

        set(mainfig,'PaperUnits','centimeters',...
         'PaperPosition',[0 0 ImageSizeX ImageSizeY],...
         'PaperSize',[ImageSizeX ImageSizeY]);
     
        k = msgbox('Saving figure...','Wait...');
        delete(findobj(k,'string','OK'));
        delete(findobj(k,'style','frame'));
        
        print(mainfig, '-dpdf','-opengl',strcat([location FileLabel],'.pdf'),strcat('-r',num2str(ImageDPI)));
        
        delete(k);
        
        close(gcf);
    end    

end

