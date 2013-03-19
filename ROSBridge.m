classdef ROSBridge
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        MASTER_URI
        client
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
            
        function message_struct = json_to_struct(message)
            message_struct = loadjson(char(message));
        end
         h, e
        function subscribe(obj, name, type, callback)
            message = strcat('{"op": "subscribe", "topic": "', name, '", "type": "', type, '"}');
            obj.send(message);
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
            disp(obj.client.message);
            % message_struct = obj.loadjson(obj.client.message);
            
        end
            
        
    end
    
end

