classdef Service
    %Service Summary of this class goes here
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
    
    
    properties (Access = private)
        ws % ros_websocket object over which to call the service
        
    end % private properties
    
    properties (SetAccess = private)
        data
        name % Name of the service to be called, string
        data_name % 
        isReceived
        
    end % private set properties
    
    methods 
        
        function obj = Service(ros_websocket, service)
            obj.ws = ros_websocket;
            obj.name = service;
            obj.data_name = strcat(regexprep(service,'[^a-zA-Z]',''), '_data__');
            addlistener(obj.ws, 'ServiceResponse', @(h,e) obj.callback(h,e));
            assignin('base', obj.data_name, struct('status',false, 'data',[]));
        end
        
        function out = call(obj, args)
            
            json_data = savejson('', args, 'ForceRootName', 0);
            message = strcat('{"op": "call_service", "service": "', obj.name, '", "args": ', json_data, '}');
            obj.ws.send(message);
            % waitfor(obj, 'isReceived', true);
            received_response = false;
            while (received_response == false)
                received_response = evalin('base', strcat(obj.data_name,'.status'));
                pause(0.01);
            end
            out = evalin('base', strcat(obj.data_name,'.data'));
            assignin('base', obj.data_name, struct('status', false, 'data', []));
            % out = 'foo';
        end
        
    end % methods
    
    methods (Access = private)
        
        function obj = callback(obj, ~, e)
            message = e.data;
            if strcmp(message.service, obj.name)
                obj.data = message.values;
                assignin('base',strcat(obj.data_name), struct('status', true,'data',message.values));
            end
        end
        
    end % methods
    
end %classdef