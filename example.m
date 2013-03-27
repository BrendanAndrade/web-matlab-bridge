% A illustrative example of how to use the web-matlab-bridge
%
% Launch roscore and a rosbridge.py node from the rosbridge_server package
% before running this example.
%
%
%   This software is covered under the 2-clause BSD license.
%   
%   Copyright (c) 2013, Brendan Andrade
%   All rights reserved.
%   
%   Redistribution and use in source and binary forms, with or without 
%   modification, are permitted provided that the following conditions 
%   are met:
%
%   Redistributions of source code must retain the above copyright 
%   notice, this list of conditions and the following disclaimer.
%   Redistributions in binary form must reproduce the above copyright 
%   notice, this list of conditions and the following disclaimer in the
%   documentation and/or other materials provided with the distribution.
% 
%   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 
%   "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
%   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS 
%   FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE 
%   COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, 
%   INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, 
%   BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; 
%   LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER 
%   CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT 
%   LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN 
%   ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
%   POSSIBILITY OF SUCH DAMAGE.

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
