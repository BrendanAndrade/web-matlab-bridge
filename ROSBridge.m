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
            
            javaaddpath('/home/bandrade/matlab-websocket/Java-WebSocket/dist/java_websocket.jar');
            import java.net.URI
            import ROSBridgeClient.*
            
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
        end
        
        function delete(obj)
            if strcmp(obj.client.getReadyState(),'OPEN')
                obj.close();
            end
        end
        
        function send(message)
            obj.client.send(message)
        end
        
        function close(obj)
            obj.client.close()
        end
            
    end
    
end

