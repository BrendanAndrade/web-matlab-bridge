

bridge = ROSBridge('ws://localhost:9090');
bridge.subscribe('test_topic','std_msgs/Int16');