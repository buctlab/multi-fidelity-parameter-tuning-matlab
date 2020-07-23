classdef MFMetaGWO < GWO
    %METAGWO Meta optimizer - GWO
    
    properties
    end
    
    methods
        function obj = MFMetaGWO(varargin)
            obj = obj@GWO(varargin{:});
        end
    end
    methods (Access = protected)
        % Override eval@GWO
        function fitness = eval(obj, position)
            % Trigger fidelity update
            obj.costFunc.fidelityUpdate(obj.costFunc,obj.iter,obj.maxIter);
            % Call super class method
            fitness = eval@GWO(obj,position);
        end
    end
    
end

