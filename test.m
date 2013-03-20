classdef test

    properties
        ws
        sub
        pub
        message
    end
    
    methods
        function obj = test
            obj.ws = ros_websocket('ws://localhost:9090');
            obj.sub = Subscriber(obj.ws, 'test_topic', 'geometry_msgs/PoseArray', @obj.callback);
            obj.pub = Publisher(obj.ws, 'test_pub', 'std_msgs/Int16');
        end
        
        function obj = callback(obj,data)
            obj.message = data;
            disp(obj.message.poses.position.x);
        end
    end
end


%{

rostopic pub --once /test_topic geometry_msgs/PoseArray '{poses: [position: {x: 0.1, y: 0.1, z: 0.0}]}'

%}