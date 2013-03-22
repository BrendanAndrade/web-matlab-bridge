classdef ros_websocket < handle
    %ros_websocket websocket object used to connect to ROS using rosbridge
    %   Allows communication with ROS through rosbridge server v2.0.
    %   
    
    events
        MessageReceived     % Notified when message received on a subscribed topic
        
        % Notified when a response to service call is received
        ServiceResponse    
        
    end
    
    properties (Access = public)
        
        client  % Java websocket client object
        
    end % public properties
    
    
    properties (SetAccess = private)
        
        MASTER_URI % Java URI object of the websocket
        message % Latest message received from websocket
        status_level % The current level of ROS statuses being sent by rosbridge
        
    end % private set properties 
    
    
    methods
        
        function obj = ros_websocket(master_uri)
            % Constructor for ROSBridge object
            %   object = ros_websocket(master_uri)
            %   master_uri is a string for the ROS master URI
            %   Example: 'ws://localhost:9090'
            %
            %   Function:
            %   Imports URI class and ROSBridgeClient class
            %   Creates and opens websocket
            
                      
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
            set(obj.client, 'MessageReceivedCallback', @(h,e) obj.message_callback(h,e));
            
        end % ros_websocket
        
        
        function delete(obj)
            % Destructor
            %   Closes the websocket if it's open.
            
            if strcmp(obj.client.getReadyState(),'OPEN')
                obj.close();
            end
            
        end % delete
        
        
        function send(obj, message)
            % Send a message (string) through the websocket to the rosbridge
            %   See rosbridge documentation for message formatting
            
            javaMethodMT('send', obj.client, message);
            % pause(0.03); % Pause for java function call to complete
        end % send
        
        function close(obj)
            % Close the websocket connection
            obj.client.close()
        end % close
        
        
    end %public methodsration: set_level.  Allowed operations: ['call_service', 'publish', 'subscribe', 'unsubscribe', 'unadvertise', 'advertise'
    
    
    methods (Access = private)
        
        function message_callback(obj, ~, e)
            message_struct = loadjson(char(e.getNewMessage)); %convert json string to struct
            disp('received')
            obj.message = message_struct;
            % Trigger event type based on what type of message is received
            switch message_struct.op
                case 'publish'
                    notify(obj, 'MessageReceived');
                case 'service_response'
                    notify(obj, 'ServiceResponse');
                case 'status'
                    disp(message_struct.msg)
            end % switch
        end % message_callback
            
    end % methods
    
    
end % classdef

