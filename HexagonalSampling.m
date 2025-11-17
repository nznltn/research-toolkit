function [subsamples, hex_x, hex_y] = HexagonalSampling(rad, subsampleRatio, r_h, r_w)

% Generates rectangular subsample points inside a hexagonal area and plots them. To be more specific, 
% this function is designed to create a pattern for rectangular spotted subsampling inside a hexagonal 
% shaped region, potentially aiming a circular object or sample. It is aimed to create constant 
% distances between the subsamples and do a represenatative and symmetrical sampling to distribute the 
% subsample centers uniformly.
% Hexagonals are useful as approximations to simulate circular regions when lines and edges are 
% required as the boundaries. A hexagonal's smallest edge to edge distance is used for fitting the 
% small side of the rectangles;  the hexagonal's largest corner to corner distance is used for fitting 
% the large side of the rectangles. After the regions is filled at the max level, selection of the 
% subsamples is made by kmeans to achieve a uniform placement of subsample centers.  
%
% Inputs:
%   rad            : radius of the circular/hexagonal area considered
%   subsampleRatio : ratio (0-1) of the object or sample on how much of the region is desired to cover or scan
%   r_h, r_w       : height and width of the rectangles
%
% Outputs:
%   subsamples : coordinates of the center of the rectangular subsamples
%   hex_x, hex_y : coordinates of hexagonals


% the shortest distance between two parallel sides
dist_short=sqrt(3)*rad;
dist_long=2*rad;

num_height = 2 * floor((dist_short/r_h)/2) + 1; % rounding down to the nearest odd number
num_width = 2 * floor((dist_long/r_w)/2) + 1;


% creating hexagonal parameters
hex_radius = rad;
theta = linspace(0, 2*pi, 7);  % 6 sides + closing point
hex_x = hex_radius * cos(theta); 
hex_y = hex_radius * sin(theta); 

% Creating preliminary grid pattern:
coord_rect_x_neg = []; 
coord_rect_x_pos = [];
coord_rect_y_neg = []; 
coord_rect_y_pos = [];

% Generating grid coordinates (negatives & positives)
for j = 1:(num_width-1)/2
    coord_rect_x_neg(end+1) = -j * r_w;
    coord_rect_x_pos(end+1) = j * r_w;
end

for i = 1:(num_height-1)/2
    coord_rect_y_neg(end+1) = -i * r_h;
    coord_rect_y_pos(end+1) = i * r_h;
end

% Ensuring proper ordering by flipping negative arrays
coord_rect_x_neg = flip(coord_rect_x_neg);
coord_rect_y_neg = flip(coord_rect_y_neg);

% Including center points and concatenating all points
coord_rect_x = [coord_rect_x_neg, 0, coord_rect_x_pos]';
coord_rect_y = [coord_rect_y_neg, 0, coord_rect_y_pos]';

% Creating a full grid using meshgrid
[X, Y] = meshgrid(coord_rect_x, coord_rect_y);

% Converting into column vectors for final coordinate list
grid_x = X(:);
grid_y = Y(:);

% Plotting the result
figure;
scatter(grid_x, grid_y, 10, 's', 'filled'); 
axis equal;
xlabel('X'); ylabel('Y');
title('Structured Rectangular Grid');

%% Masking the grid pattern with the hexagonal shape:

% Checking if points are inside the hexagon
mask = inpolygon(grid_x, grid_y, hex_x, hex_y);

inside_x = grid_x(mask);
inside_y = grid_y(mask);

figure; hold on;
plot(hex_x, hex_y, 'k-', 'LineWidth', 1.5);  % Hexagon boundary
scatter(inside_x, inside_y, 10, 's', 'filled');  % Grid points inside hexagon
axis equal;
xlabel('X'); ylabel('Y');
title('Masked Grid with Hexagonal Shape');
grid on;

inside_hex_max=[inside_x, inside_y]; % This is the max number of subsampling points that symmetrically fits in the work area 

region_area = pi*rad^2; 
rect_area=r_w*r_h; 
totalRects=round(region_area/rect_area);
RegionNumber = round(totalRects * subsampleRatio);

    if RegionNumber==1
        rand_x = (dist_long/2) * (2 * rand - 1); % Attaining a random coordinate in case the subsample number is 1.
        rand_y = (dist_short/2) * (2 * rand - 1); % Attaining a random coordinate in case the subsample number is 1.
        subsamples=[rand_x, rand_y];
        
    elseif RegionNumber==2
        subsamples=[3.0333,0; -3.0333,0]; % Attaining these two coordinates in case the subsample number is 2.
    else

       [~, subsamples] = kmeans(inside_hex_max, RegionNumber);
    end 

% The selected subsamples
figure; hold on;
plot(hex_x, hex_y, 'k-', 'LineWidth', 1.5); % Hexagon boundary
scatter(subsamples(:,1), subsamples(:,2), 20, 's', 'filled', 'MarkerFaceColor','r'); % Red squares
axis equal;
xlabel('X'); ylabel('Y');
title('Selected Subsamples');
grid on;

end 

%[appendix]{"version":"1.0"}
%---
