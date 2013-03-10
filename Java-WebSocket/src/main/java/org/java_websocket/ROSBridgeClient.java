import java.net.URI;
import java.net.URISyntaxException;

import org.java_websocket.client.WebSocketClient;
import org.java_websocket.drafts.Draft;
import org.java_websocket.drafts.Draft_10;
import org.java_websocket.handshake.ServerHandshake;

public class ROSBridgeClient extends WebSocketClient {

    public ROSBridgeClient( URI serverUri, Draft draft ) {
	super( serverUri, draft );
    }

    public ROSBridgeClient( URI serverURI ) {
	super( serverURI );
    }

    @Override
    public void onOpen( ServerHandshake handshakedata ) {
	System.out.println( "opened connection" );
    }

    @Override
    public void onMessage( String message ) {
	System.out.println( "received: " + message );
	// send( "you said: " + message );
    }

    @Override
    public void onClose( int code, String reason, boolean remote ) {
	// The codecodes are documented in class org.java_websocket.framing.CloseFrame
	System.out.println( "Connection closed by " + ( remote ? "remote peer" : "us" ) );
    }
    
    @Override
    public void onError( Exception ex ) {
	ex.printStackTrace();
	// if the error is fatal then onClose will be called additionally
    }
    
    public static void main( String[] args ) throws URISyntaxException {
	ROSBridgeClient c = new ROSBridgeClient( new URI( "ws://localhost:9090" ), new Draft_10() ); // more about drafts here: http://github.com/TooTallNate/Java-WebSocket/wiki/Drafts
	c.connect();
    }
    
}