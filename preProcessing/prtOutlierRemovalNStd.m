classdef prtOutlierRemovalNStd < prtOutlierRemoval
    % prtOutlierRemovalNStd  Removes outliers from a prtDataSet
    %
    %   NSTDOUT = prtOutlierRemovalNStd creates a pre-processing
    %   object that flags as outliers data where any of the feature values is
    %   more then nStd standard deviations from the mean of that feature.
    % 
    %   prtOutlierRemovalNStd has the following properties:
    %
    %       nStd    - The number of standard deviations at which to flag an
    %       observation as an outlier an observation (default = 3)
    %
    %   A prtPreProcNstdOutlierRemove object also inherits all properties and
    %   functions from the prtOutlierRemoval class.  For more information
    %   on how to control the behaviour of outlier removal objects, see the
    %   help for prtOutlierRemoval.
    %
    %   Example:
    %
    %   dataSet = prtDataGenUnimodal;      
    %   outlier = prtDataSetClass([-10 -10],1);
    %   dataSet = catObservations(dataSet,outlier);
    %
    %   nStdRemove = prtOutlierRemovalNStd('runMode','removeObservation');
    %
    %   nStdRemove = nStdRemove.train(dataSet);    
    %   dataSetNew = nStdRemove.run(dataSet);  
    % 
    %   subplot(2,1,1); plot(dataSet);
    %   title('Original Data');
    %   subplot(2,1,2); plot(dataSetNew);
    %   title('NstdOutlierRemove Data');
    %
     %   See Also: prtPreProc,
    %   prtOutlierRemoval,prtPreProcNstdOutlierRemove,
    %   prtOutlierRemovalMissingData,
    %   prtPreProcNstdOutlierRemoveTrainingOnly, prtOutlierRemovalNStd,
    %   prtPreProcPca, prtPreProcPls, prtPreProcHistEq,
    %   prtPreProcZeroMeanColumns, prtPreProcLda, prtPreProcZeroMeanRows,
    %   prtPreProcLogDisc, prtPreProcZmuv, prtPreProcMinMaxRows                    

    
    properties (SetAccess=private)
        % Required by prtAction
        name = 'Standard Deviation Based Outlier Removal';
        nameAbbreviation = 'nStd'
        isSupervised = false;
        
    end
    
    properties
        nStd = 3;   % The number of standard deviations beyond which to remove data
    end
    properties (SetAccess=private)
        % General Classifier Properties
        stdVector = [];
        meanVector = [];
    end
    
    methods
        
          % Allow for string, value pairs
        function Obj = prtOutlierRemovalNStd(varargin)
            Obj.isCrossValidateValid = false;  %can't cross validate because nStd changes the size of datasets
            Obj = prtUtilAssignStringValuePairs(Obj,varargin{:});
        end
    end
    
    methods
        function Obj = set.nStd(Obj,value)
            if ~isnumeric(value) || ~isscalar(value) || value < 1 || round(value) ~= value
                error('prt:prtOutlierRemovalNStd','value (%s) must be a positive scalar integer',mat2str(value));
            end
            Obj.nStd = value;
        end
    end
    
    methods (Access = protected, Hidden = true)
        
        function Obj = trainAction(Obj,DataSet)
            Obj.meanVector = mean(DataSet.getObservations(),1);
            Obj.stdVector = std(DataSet.getObservations(),1);
        end
        
        function outlierIndices = calculateOutlierIndices(Obj,DataSet)
            x = DataSet.getObservations;
            x = bsxfun(@minus,x,Obj.meanVector);
            x = bsxfun(@rdivide,x,Obj.stdVector);
            outlierIndices = abs(x) > Obj.nStd;
        end
        
    end
    
end