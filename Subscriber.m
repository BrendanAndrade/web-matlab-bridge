classdef Subscriber
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        ws
        topic
        type
        data
        callback
    end % properties
    
    methods
        
        function obj = Subscriber(ros_websocket, topic, type, callback)
            obj.ws = ros_websocket;
            obj.topic = topic;
            obj.type = type;
            obj.callback = callback;
            obj.subscribe();
        end % Subscriber
        
        function obj = subscribe(obj)
            message = strcat('{"op": "subscribe", "topic": "', obj.topic, '", "type": "', obj.type, '"}');
            obj.ws.send(message);
        end % subscribe
        
        function unsubscribe(obj)
            message = strcat('{"op": "unsubscribe", "topic": "', obj.topic, '"}');
            obj.ws.send(message);
        end % unsubscribe
            
    end % methods
    
end % classdef

