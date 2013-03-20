classdef ROSBridge
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        MASTER_URI
        client
        subscriptions = struct('names', cell(1), 'callbacks', cell(1));
    end
    
    methods
        
        function obj = ROSBridge(master_uri)
            %Constructor for ROSBridge object
            %   Adds java_websocket.jar to dynamic java path
            %   Imports URI class and ROSBridgeClient class
            %   Creates and opens websocket
            
            % javaaddpath('/home/bandrade/matlab-websocket/Java-WebSocket/dist/java_websocket.jar');
            
            % For callbacks to work, must use static classpath by editing
            % classpath.txt
            % Try using matlab handle callback on message property instead
            % of java callback...
            import java.net.URI
            import org.java_websocket.bridge.*
            
            % Create java.net.URI object for ROS_MASTER_URI
            obj.MASTER_URI = URI(master_uri);
            % Create ROSBridgeClient object
            obj.client = ROSBridgeClient(obj.MASTER_URI);
            % Connect to websocket
            retry = 0;
            while (not(strcmp(obj.client.getReadyState(),'OPEN')) && retry <= 3)
                obj.client.connect()
                pause(0.10)
                retry = retry + 1;
            end
            matlab 
            % Set callback for incoming message
            set(obj.client, 'MessageReceivedCallback', @(h,e) obj.message_callback() )
            
        end
        
        function delete(obj)
            if strcmp(obj.client.getReadyState(),'OPEN')
                obj.close();
            end
        end
        
        function send(obj, message)
            obj.client.send(message)
        end
        
        function close(obj)
            obj.client.close()
        end
           
        % Possibly delete 
        function message_struct = json_to_struct(message)
            message_struct = loadjson(char(message));
        end
        
        function obj = subscribe(obj, name, type, callback)
            message = strcat('{"op": "subscribe", "topic": "', name, '", "type": "', type, '"}');
            if find(strcmp(obj.subscriptions.names, name))
                disp(strcat('Warning: Already subscribed to ', name,'. Callback not changing.'));
            else
                obj.send(message);
                obj.subscriptions.names{end+1} = name;
                obj.subscriptions.callbacks{end+1} = callback;
            end            
        end
        
        function obj = unsubscribe(obj, name)
            message = strcat('{"op": "unsubscribe", "topic": "', name, '"}');
            sub_index = find(strcmp(obj.subscriptions.names, name));
            if sub_index > 0
                obj.subscriptions.names(sub_index) = [];
                obj.subscriptions.callbacks(sub_index) = [];
                obj.send(message);
            else
                disp(strcat('Error: Cannot unsubscribe to ', name, '. Not subscribed to topic.'));
            end
        end
        
        function advertise(obj, name, type)
            message = strcat('{"op": "advertise", "topic": "', name, '", "type": "', type, '"}');
            obj.send(message);
        end
        
        function unadvertise(obj, name)
            message = strcat('{"op": "unadvertise", "topic": "', name, '"}');
            obj.send(message);
        end
        
        function message_callback(obj)
            message_struct = loadjson(char(obj.client.message));
            switch message_struct.op
                case 'publish'
                    disp(message_struct.msg)
                case 'service_response'
                    disp(message_struct.values)
                case 'status'
                    disp(message_struct.msg)
            end
        end
            
        
    end
    
end

