javaaddpath('/home/bandrade/matlab-websocket/Java-WebSocket/dist/java_websocket.jar');
import java.net.URI
import ROSBridgeClient.*

MASTER_URI = URI('ws://localhost:9090');

client = ROSBridgeClient(MASTER_URI);


client.connect();
pause(0.10);
sub_top = '{"op": "subscribe", "topic": "/test_topic", "type": "std_msgs/Int16"}';
client.send(sub_top);
pause
client.close()
pause(0.10);
clear client