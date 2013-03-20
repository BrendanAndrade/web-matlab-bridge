cb = @(data) disp(data);

ws = ros_websocket('ws://localhost:9090');
sub = Subscriber(ws, 'test_topic', 'std_msgs/Int16', cb);
pub = Publisher(ws, 'test_pub', 'std_msgs/Int16');
