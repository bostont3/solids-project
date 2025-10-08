% ES202 Project 1 - Case 1
clear;
clc;
joint_coords = [
    0, 0;          % Joint 1 (A)
    288, 0;        % Joint 2 (B)
    31.5, 192;     % Joint 3 (C)
    256.5, 192;    % Joint 4 (D)
    63, 384;       % Joint 5 (E)
    225, 384;      % Joint 6 (F)
    31.5, 0;       % Joint 7 (G)
    256.5, 0;      % Joint 8 (H)
    63, 192;       % Joint 9 (I)
    225, 192;      % Joint 10 (J)
];
num_joints = size(joint_coords, 1);
%% Joint connections (members)
members = [
    1, 7; 7, 8; 8, 2;   
    3, 9; 9, 10; 10, 4; 
    5, 6;               
    1, 3; 3, 5;         
    2, 4; 4, 6;         
    7, 3; 8, 4;         
    9, 5; 10, 6;        
    7, 4; 9, 6;         
];
num_members = size(members, 1);
%% Member dimensions
member_sizes_in2 = 100 * ones(num_members, 1);
indices_4x4 = [2, 3, 4, 5, 6, 12, 13, 16];
member_sizes_in2(indices_4x4) = 16;
indices_4x8 = [1, 7, 14, 15, 17]; 
member_sizes_in2(indices_4x8) = 32;
%% Length and angle from horizontal of members (for static eq)
member_properties = zeros(num_members, 4);
for i = 1:num_members
    start_joint_num = members(i, 1); end_joint_num = members(i, 2);
    start_coord = joint_coords(start_joint_num, :); end_coord = joint_coords(end_joint_num, :);
    dx = end_coord(1) - start_coord(1); dy = end_coord(2) - start_coord(2);
    len = sqrt(dx^2 + dy^2); ang = atan2d(dy, dx);
    member_properties(i, :) = [start_joint_num, end_joint_num, len, ang];
end
%% All loads
b = zeros(2 * num_joints, 1);
timber_density_lb_ft3 = 26.2;
member_weights = zeros(num_members, 1);
%% Self weight
for i = 1:num_members
    member_area_ft2 = member_sizes_in2(i) / 144;
    weight_per_foot = member_area_ft2 * timber_density_lb_ft3;
    member_len_ft = member_properties(i, 3) / 12;
    member_weight = member_len_ft * weight_per_foot;
    member_weights(i) = member_weight;
    start_joint = members(i, 1); end_joint = members(i, 2);
    b(2 * start_joint) = b(2 * start_joint) - member_weight / 2;
    b(2 * end_joint) = b(2 * end_joint) - member_weight / 2;
end
% External load
b(2*5) = b(2*5) - 7500;
b(2*6) = b(2*6) - 7500; 
b(2*5 - 1) = b(2*5 - 1) + 1500; 
%% [A] matrix
A = zeros(2 * num_joints, num_members + 3);
for i = 1:num_members
    start_joint = members(i, 1); end_joint = members(i, 2);
    angle_rad = deg2rad(member_properties(i, 4));
    A(2*start_joint - 1, i) = cos(angle_rad); A(2*start_joint, i) = sin(angle_rad);
    A(2*end_joint - 1, i) = -cos(angle_rad); A(2*end_joint, i) = -sin(angle_rad);
end
% Supports
A(2*1 - 1, num_members + 1) = 1; 
A(2*1, num_members + 2) = 1; 
A(2*2, num_members + 3) = 1;
%% Static equilibrium
b = -b;
unknowns = A\b;
member_forces = unknowns(1:num_members);
reactions = unknowns(num_members+1:end);
disp('Case 1');
results_table = table(members(:,1), members(:,2), member_forces, 'VariableNames', {'Start_Joint', 'End_Joint', 'Force_lb'});
disp(results_table);
disp('Reactions:');
reactions_table = table(reactions(1), reactions(2), reactions(3), 'VariableNames', {'Ax', 'Ay', 'By'});
disp(reactions_table);

%% Total weight
total_truss_weight = 4 * sum(member_weights);
fprintf('\n Weight (Four Trusses): %.2f lb\n', total_truss_weight);

%% Plot
figure;
hold on;
axis equal;
title('Case 1');
max_force = max(abs(member_forces));
for i = 1:num_members
    start_node = members(i, 1);
    end_node = members(i, 2);
    x_coords = [joint_coords(start_node, 1), joint_coords(end_node, 1)];
    y_coords = [joint_coords(start_node, 2), joint_coords(end_node, 2)];
    force = member_forces(i);
    if force > 0 
        line_color = [0, 0, 1]; 
    elseif force < 0 
        line_color = [1, 0, 0]; 
    else
        line_color = [0.5, 0.5, 0.5]; 
    end
    plot(x_coords, y_coords, 'Color', line_color, 'LineWidth', 2 + abs(force)/max_force * 3);
end
plot(joint_coords(:,1), joint_coords(:,2), 'ko', 'MarkerFaceColor', 'k', 'MarkerSize', 8);
text(joint_coords(:,1)+5, joint_coords(:,2), num2str((1:num_joints)'));
hold off;