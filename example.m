% A illustrative example of how to use the web-matlab-bridge
%
% Launch roscore and a rosbridge.py node from the rosbridge_server package
% before running this example.
%
% Copywrite 2013 Brendan Andrade

master_uri = 'ws://localhost:9090';
ws = ros_websocket(master_uri);

pub = Publisher(ws,'chatter','std_msgs/Int16');
sub = Subscriber(ws, 'chatter', 'std_msgs/Int16');

addlistener(sub,'OnMessageReceived',@(h,e) disp(strcat('Received: ', int2str(e.data.data))));

for i=1:5
   pub.publish(i); 
end

pub.unadvertise
sub.unsubscribe
pause(0.1)
ws.delete
