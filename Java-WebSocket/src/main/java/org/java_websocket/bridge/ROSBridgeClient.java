/*   
This software is covered under the 2-clause BSD license.
   
Copyright (c) 2013, Brendan Andrade
All rights reserved.

Redistribution and use in source and binary forms, with or without 
modification, are permitted provided that the following conditions 
are met:

Redistributions of source code must retain the above copyright 
notice, this list of conditions and the following disclaimer.
  
Redistributions in binary form must reproduce the above copyright 
notice, this list of conditions and the following disclaimer in the
documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 
"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS 
FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE 
COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, 
INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, 
BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; 
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER 
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT 
LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN 
ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
POSSIBILITY OF SUCH DAMAGE.
*/






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

