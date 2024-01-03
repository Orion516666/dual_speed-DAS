function [min_AIC_index] = AIC_picker(channel_data)
% ABOUT:
%       author               - Xinlong Dong(shanghaitech university)
%       date                 - 2024.1.3
%       last update          - 2024.1.3

    % AIC value
    aic_value = zeros(1, length(channel_data) - 1);
    for k = 2:length(channel_data) - 2
        variance1 = var(channel_data(1:k));
        variance2 = var(channel_data(k+1:end));
        
        aic_value(k) = k*log(variance1) + (length(channel_data) - k + 1) * log(variance2);   
    end
    
    % AIC weight
    aic_value = aic_value(2:end-1);
    aic_min = min(aic_value(:));

    aic_diff = exp(-(aic_value - aic_min) / 2);

    aic_weights = aic_diff ./ sum(aic_diff);

    % min_AIC_index
    min_AIC_index = sum(aic_weights .* (2:length(channel_data) - 2)) + 1;
    min_AIC_index = round(min_AIC_index);    
end