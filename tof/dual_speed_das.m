%% 这是DAS_circle的代码
function [reconstruction_image, CF, in_out_ratio] = dual_speed_das(in_ROI, ROI_TOF,ROI_size,transducer_order, pa_sensor_data, sample_interval)

    reconstruction_image = zeros(ROI_size(1), ROI_size(2));
    CF = 0;
    in_ROI_abs_sum = 0;
    out_ROI_abs_sum = 0;

    % image_size = size(reconstruction_image);
    sensor_data_size = size(pa_sensor_data);

    max_step = 1;
    min_step = sensor_data_size(2);
    
    delay_step = round(ROI_TOF / sample_interval);
    for i = 1:length(ROI_TOF)

        % one_point_tof_step 1*256
        one_point_tof_step = delay_step(i, :);
        if  min(one_point_tof_step) < min_step
            min_step = min(one_point_tof_step);
        end
        if  max(one_point_tof_step) > max_step
            max_step = max(one_point_tof_step);
        end

        point_data_from_channels = pa_sensor_data(sub2ind(sensor_data_size, transducer_order', one_point_tof_step));
        
        reconstruction_image(i) = sum(point_data_from_channels(:));

        point_data_from_channels_square = point_data_from_channels.^2;
        
        if  in_ROI(i) == 1
            in_ROI_abs_sum = in_ROI_abs_sum + sum(abs(point_data_from_channels(:)));

            CF = CF + reconstruction_image(i)^2 / (sensor_data_size(1) * sum(point_data_from_channels_square(:)));
        else
            out_ROI_abs_sum = out_ROI_abs_sum+ sum(abs(point_data_from_channels(:)));
        end
    end

    in_out_ratio = in_ROI_abs_sum / out_ROI_abs_sum;
    CF = CF / (max_step - min_step);
end


% one_point_tof = ROI_TOF(1, :);
% 
% a = one_point_tof;
% for i = 1:256
%     a(i) = one_point_tof(transducer_order(i));
% end



