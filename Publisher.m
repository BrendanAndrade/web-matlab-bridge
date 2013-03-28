classdef Publisher
    %Publisher Summary of this class goes here
    %   Detailed explanation goes here
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
    %   
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
    
    properties (SetAccess = private)
        topic
        type
        ws
    end
    
    methods
        
        function obj = Publisher(ros_websocket, topic, type)
            obj.ws = ros_websocket;
            obj.topic = topic;
            obj.type = type;
            obj.advertise();
        end
        
        function advertise(obj)
            message = strcat('{"op": "advertise", "topic": "', obj.topic, '", "type": "', obj.type, '"}');
            obj.ws.send(message);
        end
        
        function unadvertise(obj)
            message = strcat('{"op": "unadvertise", "topic": "', obj.topic, '"}');
            obj.ws.send(message);
        end
        
        function publish(obj, data)
            json_data = savejson('', data, 'ForceRootName', false);
            message = strcat('{"op": "publish", "topic": "', obj.topic, '", "msg": ', json_data, '}');
            obj.ws.send(message);      
        end
    end
    
end

