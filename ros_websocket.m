classdef ros_websocket
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        MASTER_URI
        client
    end % properties
    
    methods
        
        function obj = ros_websocket(master_uri)
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
            
        end % ros_websocket
        
        function delete(obj)
            %Destructor for ROSBridge object
            %   Closes the websocket if it's open.
            if strcmp(obj.client.getReadyState(),'OPEN')
                obj.close();
            end
        end % delete
        
        function send(obj, message)
            obj.client.send(message)
        end % send
        
        function close(obj)
            obj.client.close()
        end % close
           
        % Possibly delete 
        function message_struct = json_to_struct(message)
            message_struct = loadjson(char(message));
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
            end % switch
        end % message_callback
            
    end % methods
    
end % classdef

