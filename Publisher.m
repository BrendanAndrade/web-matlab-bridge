classdef Publisher
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        topic
        type
        data
        ws
    end
    
    methods
        
        function obj = Publisher(ros_websocket, topic, type)
            obj.ws = ros_websocket;
            obj.topic = topic;
            obj.type = type;
            obj.advertise();
        end
        
        function advertise(obj)
            message = strcat('{"op": "advertise", "topic": "', obj.topic, '", "type": "', obj.type, '"}');
            obj.ws.send(message);
        end
        
        function unadvertise(obj)
            message = strcat('{"op": "unadvertise", "topic": "', obj.topic, '"}');
            obj.ws.send(message);
        end
        
        function publish(obj, data)
            json_data = savejson('data', data);
            message = strcat('{"op": "publish", "topic": "', obj.topic, '", "msg": ', json_data, '}');
            obj.ws.send(message);      
        end
    end
    
end

