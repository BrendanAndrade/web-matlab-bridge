classdef Subscriber
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        name
        type
        data
    end
    
    methods
        function obj = Subscriber(name, type, callback)
            obj.name = name;
            obj.type = type;
        end
        
        function set_data(obj, data)
            obj.data = data;
        end
    end
    
end

