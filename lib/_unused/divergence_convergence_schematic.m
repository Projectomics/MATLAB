function divergence_convergence_schematic

      %convergence
      x = [0];
      y = [5];
      scatter(x, y, 'MarkerFaceColor', 'none', 'MarkerEdgeColor', 'none');
      hold on;
      
      %divergence      
%       region = 'A38';
%       x = [0.2];
%       y = [2619.114];
%       scatter(x, y, 'MarkerFaceColor', 'blue', 'MarkerEdgeColor', 'blue'); %(I)LEC   
%       y = [12472.07];
%       scatter(x, y, 'MarkerFaceColor', 'blue', 'MarkerEdgeColor', 'blue'); %(C)LEC 
%       y = [526.6496];
%       scatter(x, y, 'MarkerFaceColor', 'blue', 'MarkerEdgeColor', 'blue'); %(I)Sub
%       y = [12549.07];
%       scatter(x, y, 'MarkerFaceColor', 'blue', 'MarkerEdgeColor', 'blue'); %(C)Sub
%       y = [4136.635];
%       scatter(x, y, 'MarkerFaceColor', 'blue', 'MarkerEdgeColor', 'blue'); %(I)Field CA1+2+3
%       y = [7534.204];
%       scatter(x, y, 'MarkerFaceColor', 'blue', 'MarkerEdgeColor', 'blue'); %(C)Field CA1+2+3
%       y = [478.0163];
%       scatter(x, y, 'MarkerFaceColor', 'blue', 'MarkerEdgeColor', 'blue'); %(I)DG  
%       ylim([-5000, 20000]);
% 
%       region = 'B27';
%       x = [0.4];
%       y = [686.461];
%       scatter(x, y, 'MarkerFaceColor', 'red', 'MarkerEdgeColor', 'red'); %(I)ParaS   
%       y = [16807.63];
%       scatter(x, y, 'MarkerFaceColor', 'red', 'MarkerEdgeColor', 'red'); %(C)ParaS 
%       y = [1791.985];
%       scatter(x, y, 'MarkerFaceColor', 'red', 'MarkerEdgeColor', 'red'); %(I)dMEC
%       y = [15242.22];
%       scatter(x, y, 'MarkerFaceColor', 'red', 'MarkerEdgeColor', 'red'); %(C)dMEC 
%       ylim([-5000, 20000]);
%       
%       region = 'D19';
%       x = [0.6];
%       y = [9971.712];
%       scatter(x, y, 'MarkerFaceColor', 'none', 'MarkerEdgeColor', 'black'); %(I) mATN+LGN   
%       y = [11983.92];
%       scatter(x, y, 'MarkerFaceColor', 'none', 'MarkerEdgeColor', 'black'); %(I)HYP+LMN 
%       y = [1486.53];
%       scatter(x, y, 'MarkerFaceColor', 'none', 'MarkerEdgeColor', 'black'); %(I)MidB 
%       ylim([-5000, 20000]);
% 
%       region = 'A38,B27,D19';
        
        %convergence       
%       region = 'dMEC';
%       x = [0.1, 0.1];
%       y = [0, 2348.08];
%       plot(x, y, 'blue', 'LineWidth', 1.5);
%       x = [0.2, 0.2];
%       y = [0, 1791.985];
%       plot(x, y, 'red', 'LineWidth', 1.5);      
%       x = [0.3, 0.3];
%       y = [0, 1512.395];
%       plot(x, y, 'black', 'LineWidth', 1.5);      
%       x = [0.4, 0.4];
%       y = [0, 663.1415];
%       plot(x, y, 'green', 'LineWidth', 1.5);
%       
%       x = [0.6, 0.6];
%       y = [0, 12501.68];
%       plot(x, y, 'blue', 'LineWidth', 1.5);      
%       x = [0.7, 0.7];
%       y = [0, 15242.22];
%       plot(x, y, 'red', 'LineWidth', 1.5);      
%       x = [0.8, 0.8];
%       y = [0, 14162.02];
%       ylim([-5000, 20000]);
%       plot(x, y, 'cyan', 'LineWidth', 1.5);
%       
%       region = '(C)Sub';   
%       x = [0.6, 0.6];
%       y = [0, 12549.07];
%       plot(x, y, 'blue', 'LineWidth', 1.5);           
%       x = [0.7, 0.7];
%       y = [0, 15695.96];
%       ylim([-5000, 20000]);
%       plot(x, y, 'red', 'LineWidth', 1.5);
%       
%       region = 'ParaS';   
%       x = [0.3, 0.3];
%       y = [0, 686.461];
%       plot(x, y, 'red', 'LineWidth', 1.5);         
%       x = [0.4, 0.4];
%       y = [0, 1485.326];
%       ylim([-5000, 20000]);
%       plot(x, y, 'black', 'LineWidth', 1.5);
% 
%       x = [0.7, 0.7];
%       y = [0, 12944.99];
%       plot(x, y, 'blue', 'LineWidth', 1.5);          
%       x = [0.8, 0.8];
%       y = [0, 16807.63];
%       ylim([-5000, 20000]);
%       plot(x, y, 'red', 'LineWidth', 1.5);

      region = 'LEC';   
      x = [0.3, 0.3];
      y = [0, 2619.114];
      plot(x, y, 'blue', 'LineWidth', 1.5);
      scatter(0.3, 2320.8237, 'blue', 'x', 'LineWidth', 1.5); 
      scatter(0.3, 3351.668893, 'blue', 'x', 'LineWidth', 1.5); 
      
      x = [0.4, 0.4];
      y = [0, 1899.638];
      plot(x, y, 'red', 'LineWidth', 1.5);
      scatter(0.4, 1500.725271, 'red', 'x', 'LineWidth', 1.5); 
      scatter(0.4, 2387.750688, 'red', 'x', 'LineWidth', 1.5);
      
      x = [0.5, 0.5];
      y = [0, 1734.427];
      scatter(0.5, 1661.269735, 'black', 'x', 'LineWidth', 1.5); 
      scatter(0.5, 1807.585154, 'black', 'x', 'LineWidth', 1.5);
      
      ylim([-5000, 20000]);
      plot(x, y, 'black', 'LineWidth', 1.5);

      x = [0.7, 0.7];
      y = [0, 12472.07];
      plot(x, y, 'blue', 'LineWidth', 1.5);
      scatter(0.7, 11038.09597, 'blue', 'x', 'LineWidth', 1.5); 
      scatter(0.7, 14272.91634, 'blue', 'x', 'LineWidth', 1.5);
      
      x = [0.8, 0.8];
      y = [0, 15506.84];
      ylim([-5000, 20000]);
      plot(x, y, 'red', 'LineWidth', 1.5); 
      scatter(0.8, 13701.43599, 'red', 'x', 'LineWidth', 1.5); 
      scatter(0.8, 17017.67846, 'red', 'x', 'LineWidth', 1.5);
      
      
      x = [1];
      y = [5];
      scatter(x, y, 'MarkerFaceColor', 'none', 'MarkerEdgeColor', 'none');
      %str = strcat('.././output/', region, '_divergence');
      str = strcat('./output/', region, '_divergence');
      saveas(gcf, str);      

end