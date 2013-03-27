classdef ROSCallbackData < event.EventData
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        data
    end
    
    methods
        function obj = ROSCallbackData(data)
            obj.data = data;
        end
        
    end
    
end

