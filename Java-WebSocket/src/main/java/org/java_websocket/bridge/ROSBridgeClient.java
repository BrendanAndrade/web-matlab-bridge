package org.java_websocket.bridge;

import java.net.URI;
import java.net.URISyntaxException;

import java.util.Iterator;
import java.util.ArrayList;
import java.util.List;
import java.util.EventObject;
import java.util.EventListener;

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import javax.swing.JFrame;
import javax.swing.JButton;
import javax.swing.JPanel;
import javax.swing.SwingUtilities;


import org.java_websocket.client.WebSocketClient;
import org.java_websocket.drafts.Draft;
import org.java_websocket.drafts.Draft_10;
import org.java_websocket.handshake.ServerHandshake;


public class ROSBridgeClient extends WebSocketClient {

    public String message;

    private List _listeners = new ArrayList();
    private String _message;
    private ShutdownButton button = new ShutdownButton();

    public ROSBridgeClient( URI serverUri, Draft draft ) {
	super( serverUri, draft );
	this.button.setVisible(true);
    }

    public ROSBridgeClient( URI serverURI ) {
	super( serverURI );
	this.button.setVisible(true);
    }

    private class ShutdownButton extends JFrame {
	public ShutdownButton() {
	    int x = 300;
	    int y = 100;
	    JPanel panel = new JPanel();
	    getContentPane().add(panel);
	    
	    panel.setLayout(null);
	    
	    JButton quitButton = new JButton("Manually Close Java Websocket");
	    quitButton.setBounds(5,5,x-10,y-35);
	    quitButton.addActionListener(new ActionListener() {
		    public void actionPerformed(ActionEvent event) {
			onPress();
		    }
		});
	    panel.add(quitButton);
	    setTitle("Java Websocket Open");
	    setSize(x,y);
	    setLocationRelativeTo(null);
	    setDefaultCloseOperation(DO_NOTHING_ON_CLOSE);
	}

	private void onPress() {
	    close();
	    dispose();		
	}
    }
	    

    @Override
    public void onOpen( ServerHandshake handshakedata ) {
	System.out.println( "opened connection" );
    }

    @Override
    public void onMessage( String message ) {
	// System.out.println( "received: " + message );
	// send( "you said: " + message );
	this.message = message;
	_fireMessageEvent( message );
    }

    @Override
    public void onClose( int code, String reason, boolean remote ) {
	// The codecodes are documented in class org.java_websocket.framing.CloseFrame
	System.out.println( "Connection closed by " + ( remote ? "remote peer" : "us" ) );
	this.button.dispose();
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

    private synchronized void _fireMessageEvent(String message) {
	MessageEvent message_event = new MessageEvent( this, message);
	Iterator listeners = _listeners.iterator();
	while (listeners.hasNext() ) {
	    ( (MessageListener) listeners.next() ).messageReceived( message_event );
	}
    }

    public class MessageEvent extends EventObject {
	private String message;
	public MessageEvent( Object source, String message) {
	    super( source );
	    this.message = message;
	}

	// Method from returning message to callback
	public String message() {
	    return this.message;
	}

    }

    public interface MessageListener extends java.util.EventListener {
	 void messageReceived( MessageEvent event );
    }
    
}

