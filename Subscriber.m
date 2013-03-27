classdef Subscriber < handle
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
       
    events
        OnMessageReceived
    end
    
    properties
        ws
        topic
        type
        data
    end % properties
    
    methods
        
        function obj = Subscriber(ros_websocket, topic, type)
            obj.ws = ros_websocket;
            obj.topic = topic;
            obj.type = type;
            obj.subscribe();
            addlistener(obj.ws, 'MessageReceived', @(h,e) obj.OnWSMessageReceived(h,e));
        end % Subscriber
        
        function obj = subscribe(obj)
            message = strcat('{"op": "subscribe", "topic": "', obj.topic, '", "type": "', obj.type, '"}');
            obj.ws.send(message);
        end % subscribe
        
        function unsubscribe(obj)
            message = strcat('{"op": "unsubscribe", "topic": "', obj.topic, '"}');
            obj.ws.send(message);
        end % unsubscribe
        
        function obj = OnWSMessageReceived(obj,~,e)
            message = e.data;
            if strcmp(message.topic, obj.topic)
                obj.data = message.msg;
                notify(obj, 'OnMessageReceived',ROSCallbackData(message.msg));
            end
        end
            
    end % methods
    
end % classdef

