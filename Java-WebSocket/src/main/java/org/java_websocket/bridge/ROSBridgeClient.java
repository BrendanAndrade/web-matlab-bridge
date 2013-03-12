package org.java_websocket.bridge;

import java.net.URI;
import java.net.URISyntaxException;

import java.util.Iterator;
import java.util.ArrayList;
import java.util.List;
import java.util.EventObject;
import java.util.EventListener;

import org.java_websocket.client.WebSocketClient;
import org.java_websocket.drafts.Draft;
import org.java_websocket.drafts.Draft_10;
import org.java_websocket.handshake.ServerHandshake;

public class ROSBridgeClient extends WebSocketClient {

    public String message;

    private List _listeners = new ArrayList();
    private String _message;

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
	this.message = message;
	_fireMessageEvent();
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





    public synchronized void addMessageListener( MessageListener l ) {
	_listeners.add( l );
    }

    public synchronized void removeMessageListener( MessageListener l) {
	_listeners.remove( l );
    }

    private synchronized void _fireMessageEvent() {
	MessageEvent message = new MessageEvent( this, _message);
	Iterator listeners = _listeners.iterator();
	while (listeners.hasNext() ) {
	    ( (MessageListener) listeners.next() ).messageReceived( message );
	}
    }

    public class MessageEvent extends EventObject {
	private String _message;
 
	public MessageEvent( Object source, String message) {
	    super( source );
	    _message = message;
	}

	public String message() {
	    return _message;
	}

    }

    public interface MessageListener extends java.util.EventListener {
	 void messageReceived( MessageEvent event );
    }
    
}

