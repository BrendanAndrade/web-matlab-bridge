javaaddpath('/home/bandrade/matlab-websocket/Java-WebSocket/dist/');
import java.net.URI

MASTER_URI = URI('ws://localhost:9090');

client = ROSBridgeClient(MASTER_URI);


client.connect();
pause(0.10);
sub_top = '{"op": "subscribe", "topic": "/waypoint_input", "type": "geometry_msgs/PoseArray"}';
client.send(sub_top);
pause
client.close()
pause(0.10);
clear client