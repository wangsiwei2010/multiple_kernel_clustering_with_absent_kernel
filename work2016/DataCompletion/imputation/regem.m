function [X, M, C, Xerr] = regem(X, options)
%REGEM   Imputation of missing values with regularized EM algorithm.
%
%    [X, M, C, Xerr] = REGEM(X, OPTIONS) replaces missing values
%    (NaNs) in the data matrix X with imputed values. REGEM
%    returns
%  
%       X,    the data matrix with imputed values substituted for NaNs,  
%       M,    the estimated mean of X, 
%       C,    the estimated covariance matrix of X,
%       Xerr, an estimated standard error of the imputed values.
%  
%    Missing values are imputed with a regularized expectation
%    maximization (EM) algorithm. In an iteration of the EM algorithm,
%    given estimates of the mean and of the covariance matrix are
%    revised in three steps. First, for each record X(i,:) with
%    missing values, the regression parameters of the variables with
%    missing values on the variables with available values are
%    computed from the estimates of the mean and of the covariance
%    matrix. Second, the missing values in a record X(i,:) are filled
%    in with their conditional expectation values given the available
%    values and the estimates of the mean and of the covariance
%    matrix, the conditional expectation values being the product of
%    the available values and the estimated regression
%    coefficients. Third, the mean and the covariance matrix are
%    re-estimated, the mean as the sample mean of the completed
%    dataset and the covariance matrix as the sum of the sample
%    covariance matrix of the completed dataset and an estimate of the
%    conditional covariance matrix of the imputation error. 
%
%    In the regularized EM algorithm, the parameters of the regression
%    models are estimated by a regularized regression method. By
%    default, the parameters of the regression models are estimated by
%    an individual ridge regression for each missing value in a
%    record, with one regularization parameter (ridge parameter) per
%    missing value.  Optionally, the parameters of the regression
%    models can be estimated by a multiple ridge regression for each
%    record with missing values, with one regularization parameter per
%    record with missing values. The regularization parameters for the
%    ridge regressions are selected as the minimizers of the
%    generalized cross-validation (GCV) function. As another option,
%    the parameters of the regression models can be estimated by
%    truncated total least squares. The truncation parameter, a
%    discrete regularization parameter, is fixed and must be given as
%    an input argument. The regularized EM algorithm with truncated
%    total least squares is faster than the regularized EM algorithm
%    with with ridge regression, requiring only one eigendecomposition
%    per iteration instead of one eigendecomposition per record and
%    iteration. But an adaptive choice of truncation parameter has not
%    been implemented for truncated total least squares. So the
%    truncated total least squares regressions can be used to compute
%    initial values for EM iterations with ridge regressions, in which
%    the regularization parameter is chosen adaptively.
%  
%    As default initial condition for the imputation algorithm, the
%    mean of the data is computed from the available values, mean
%    values are filled in for missing values, and a covariance matrix
%    is estimated as the sample covariance matrix of the completed
%    dataset with mean values substituted for missing
%    values. Optionally, initial estimates for the missing values and
%    for the covariance matrix estimate can be given as input
%    arguments.
% 
%    The OPTIONS structure specifies parameters in the algorithm:
%
%     Field name         Parameter                                  Default
%
%     OPTIONS.regress    Regression procedure to be used:           'mridge'
%                        'mridge': multiple ridge regression
%                        'iridge': individual ridge regressions
%                        'ttls':   truncated total least squares 
%                                  regression 
%  
%     OPTIONS.stagtol    Stagnation tolerance: quit when            5e-3 
%                        consecutive iterates of the missing
%                        values are so close that
%                          norm( Xmis(it)-Xmis(it-1) ) 
%                             <= stagtol * norm( Xmis(it-1) )
%  
%     OPTIONS.maxit      Maximum number of EM iterations.           30
%  
%     OPTIONS.inflation  Inflation factor for the residual          1 
%                        covariance matrix. Because of the 
%                        regularization, the residual covariance 
%                        matrix underestimates the conditional 
%                        covariance matrix of the imputation 
%                        error. The inflation factor is to correct 
%                        this underestimation. The update of the 
%                        covariance matrix estimate is computed 
%                        with residual covariance matrices 
%                        inflated by the factor OPTIONS.inflation,
%                        and the estimates of the imputation error
%                        are inflated by the same factor. 
%
%     OPTIONS.disp       Diagnostic output of algorithm. Set to     1
%                        zero for no diagnostic output.
%
%     OPTIONS.regpar     Regularization parameter.                  not set 
%                        For ridge regression, set regpar to 
%                        sqrt(eps) for mild regularization; leave 
%                        regpar unset for GCV selection of
%                        regularization parameters.
%                        For TTLS regression, regpar must be set
%                        and is a fixed truncation parameter. 
%
%     OPTIONS.relvar_res Minimum relative variance of residuals.    5e-2
%                        From the parameter OPTIONS.relvar_res, a
%                        lower bound for the regularization 
%                        parameter is constructed, in order to 
%                        prevent GCV from erroneously choosing 
%                        too small a regularization parameter.
%  
%     OPTIONS.minvarfrac Minimum fraction of total variation in     0
%                        standardized variables that must be 
%                        retained in the regularization.
%                        From the parameter OPTIONS.minvarfrac, 
%                        an approximate upper bound for the 
%                        regularization parameter is constructed. 
%                        The default value OPTIONS.minvarfrac = 0 
%                        essentially corresponds to no upper bound 
%                        for the regularization parameter.   
%  
%     OPTIONS.Xmis0      Initial imputed values. Xmis0 is a         not set
%                        (possibly sparse) matrix of the same 
%                        size as X with initial guesses in place
%                        of the NaNs in X.  
%  
%     OPTIONS.C0         Initial estimate of covariance matrix.     not set
%                        If no initial covariance matrix C0 is 
%                        given but initial estimates Xmis0 of the 
%                        missing values are given, the sample 
%                        covariance matrix of the dataset 
%                        completed with initial imputed values is 
%                        taken as an initial estimate of the 
%                        covariance matrix. 
%  
%     OPTIONS.Xcmp       Display the weighted rms difference        not set
%                        between the imputed values and the 
%                        values given in Xcmp, a matrix of the 
%                        same size as X but without missing 
%                        values. By default, REGEM displays 
%                        the rms difference between the imputed 
%                        values at consecutive iterations. The 
%                        option of displaying the difference 
%                        between the imputed values and reference 
%                        values exists for testing purposes.
%
%     OPTIONS.neigs      Number of eigenvalue-eigenvector pairs     not set
%                        to be computed for TTLS regression. 
%                        By default, all nonzero eigenvalues and 
%                        corresponding eigenvectors are computed. 
%                        By computing fewer (neigs) eigenvectors, 
%                        the computations can be accelerated, but 
%                        the residual covariance matrices become 
%                        inaccurate. Consequently, the residual 
%                        covariance matrices underestimate the 
%                        imputation error conditional covariance 
%                        matrices more and more as neigs is 
%                        decreased.
  
%    References: 
%    [1] T. Schneider, 2001: Analysis of incomplete climate data:
%        Estimation of mean values and covariance matrices and
%        imputation of missing values. Journal of Climate, 14,
%        853--871.  
%    [2] R. J. A. Little and D. B. Rubin, 1987: Statistical
%        Analysis with Missing Data. Wiley Series in Probability
%        and Mathematical Statistics. (For EM algorithm.) 
%    [3] P. C. Hansen, 1997: Rank-Deficient and Discrete Ill-Posed
%        Problems: Numerical Aspects of Linear Inversion. SIAM
%        Monographs on Mathematical Modeling and Computation.
%        (For regularization techniques, including the selection of 
%        regularization parameters.)
  
  error(nargchk(1, 2, nargin))     % check number of input arguments 
  
  if ndims(X) > 2,  error('X must be vector or 2-D array.'); end
  % if X is a vector, make sure it is a column vector (a single variable)
  if length(X)==prod(size(X))      
    X = X(:);                      
  end 
  [n, p]       = size(X);
  % number of degrees of freedom for estimation of covariance matrix
  dofC         = n - 1;            % use degrees of freedom correction       
  
  % ==============           process options        ========================
  if nargin ==1 | isempty(options)
    fopts      = [];
  else
    fopts      = fieldnames(options);
  end

  % initialize options structure for regression modules
  optreg       = [];
  
  if strmatch('regress', fopts)
    regress    = lower(options.regress);
    switch regress
     case {'mridge', 'iridge'}
      % OK
     case {'ttls'}
      
      if isempty(strmatch('regpar', fopts))
	error('Truncation parameter for TTLS regression must be given.')
      else
	trunc  = min([options.regpar, n-1, p]);
      end
      
      if strmatch('neigs', fopts)
	neigs  = options.neigs;
      else
	neigs  = min(n-1, p);
      end
      
     otherwise
      
      error(['Unknown regression method ', regress])
      
    end
  else
    regress    = 'mridge';
  end
  
  if strmatch('stagtol', fopts)
    stagtol    = options.stagtol;
  else
    stagtol    = 5e-2;
  end

  if strmatch('maxit', fopts)
    maxit      = options.maxit;
  else
    maxit      = 10;
  end
  
  if strmatch('inflation', fopts)
    inflation  = options.inflation;
  else
    inflation  = 1;
  end
  
  if strmatch('relvar_res', fopts)
    optreg.relvar_res = options.relvar_res; 
  else
    optreg.relvar_res = 5e-2; 
  end
  
  if strmatch('minvarfrac', fopts)
    optreg.minvarfrac = options.minvarfrac; 
  else
    optreg.minvarfrac = 0; 
  end

  h_given      = 0;
  if strmatch('regpar', fopts)
    h_given    = 1;
    optreg.regpar = options.regpar;
    if strmatch(regress, 'iridge')
      regress  = 'mridge';
    end
  end
  
  if strmatch('disp', fopts);
    dispon     = options.disp;
  else
    dispon     = 1;
  end
    
  if strmatch('Xmis0', fopts);
    Xmis0_given= 1;
    Xmis0      = options.Xmis0;
    if any(size(Xmis0) ~= [n,p])
      error('OPTIONS.Xmis0 must have the same size as X.')
    end
  else
    Xmis0_given= 0;
  end
  
  if strmatch('C0', fopts);
    C0_given   = 1;
    C0         = options.C0;
    if any(size(C0) ~= [p, p])
      error('OPTIONS.C0 has size incompatible with X.')
    end
  else
    C0_given   = 0;
  end
  
  if strmatch('Xcmp', fopts);
    Xcmp_given = 1;
    Xcmp       = options.Xcmp;
    if any(size(Xcmp) ~= [n,p])
      error('OPTIONS.Xcmp must have the same size as X.')
    end
    sXcmp      = std(Xcmp);
  else
    Xcmp_given = 0;
  end
  
  % =================           end options        =========================
    
  % get indices of missing values and initialize matrix of imputed values
  indmis       = find(isnan(X));
  nmis         = length(indmis);
  if nmis == 0
    warning('No missing value flags found.')
    return                                      % no missing values
  end
  [jmis,kmis]  = ind2sub([n, p], indmis);
  Xmis         = sparse(jmis, kmis, NaN, n, p); % matrix of imputed values
  Xerr         = sparse(jmis, kmis, Inf, n, p); % standard error imputed vals.
  
  % for each row of X, assemble the column indices of the available
  % values and of the missing values
  kavlr        = cell(n,1);
  kmisr        = cell(n,1);
  for j=1:n
    kavlr{j}   = find(~isnan(X(j,:)));
    kmisr{j}   = find(isnan(X(j,:)));
  end

  if dispon
    disp(sprintf('\nREGEM:'))
    disp(sprintf('\tPercentage of values missing:      %5.2f', nmis/(n*p)*100))
    disp(sprintf('\tStagnation tolerance:              %9.2e', stagtol))
    disp(sprintf('\tMaximum number of iterations:     %3i', maxit))

    if (inflation ~= 1)
      disp(sprintf('\tResidual (co-)variance inflation:  %6.3f ', inflation))
    end
      
    if Xmis0_given & C0_given
      disp(sprintf(['\tInitialization with given imputed values and' ...
		    ' covariance matrix.']))
    elseif C0_given
      disp(sprintf(['\tInitialization with given covariance' ...
		    ' matrix.']))
    elseif Xmis0_given
      disp(sprintf(['\tInitialization with given imputed values.']))
    else
      disp(sprintf('\tInitialization of missing values by mean substitution.')) 
    end
    
    switch regress
     case 'mridge'
      disp(sprintf('\tOne multiple ridge regression per record:'))
      disp(sprintf('\t==> one regularization parameter per record.'))
     case 'iridge'
      disp(sprintf('\tOne individual ridge regression per missing value:'))
      disp(sprintf('\t==> one regularization parameter per missing value.'))
     case 'ttls'
      disp(sprintf('\tOne total least squares regression per record.'))
      disp(sprintf('\tFixed truncation parameter:      %4i', trunc))
    end

    if h_given
      disp(sprintf('\tFixed regularization parameter:    %9.2e', optreg.regpar))
    end
    
    if Xcmp_given
      disp(sprintf(['\n\tIter \tmean(peff) \t|X-Xcmp|/std(Xcmp) ' ...
		    '\t|D(Xmis)|/|Xmis|'])) 
    else
      disp(sprintf(['\n\tIter \tmean(peff) \t|D(Xmis)| ' ...
		    '\t|D(Xmis)|/|Xmis|']))       
    end
  end

  % initial estimates of missing values
  if Xmis0_given
    % substitute given guesses for missing values
    X(indmis)  = Xmis0(indmis);
    [X, M]     = center(X);        % center data to mean zero
  else
    [X, M]     = center(X);        % center data to mean zero
    X(indmis)  = zeros(nmis, 1);   % fill missing entries with zeros
  end
      
  if C0_given
    C          = C0;
  else
    C          = X'*X / dofC;      % initial estimate of covariance matrix
  end
  
  it           = 0;
  rdXmis       = Inf;
  while (it < maxit & rdXmis > stagtol)
    it         = it + 1;    

    % initialize for this iteration ...
    CovRes     = zeros(p,p);       % ... residual covariance matrix
    peff_ave   = 0;                % ... average effective number of variables 

    % scale variables to unit variance
    D          = sqrt(diag(C));  
    const      = (abs(D) < eps);   % test for constant variables
    nconst     = ~const;
    if sum(const) ~= 0             % do not scale constant variables
      D        = D .* nconst + 1*const;
    end
    X          = X ./ repmat(D', n, 1);
    % correlation matrix
    C          = C ./ repmat(D', p, 1) ./ repmat(D, 1, p);
    
    if strmatch(regress, 'ttls')
      % compute eigendecomposition of correlation matrix
      [V, d]   = peigs(C, neigs);
      peff_ave = trunc;     
    end
    
    for j=1:n                      % cycle over records
      pm       = length(kmisr{j}); % number of missing values in this record
      if pm > 0	
	pa     = p - pm;           % number of available values in this record

	% regression of missing variables on available variables
	switch regress
	 case 'mridge'
	  % one multiple ridge regression per record
	  [B, S, h, peff]   = mridge(C(kavlr{j},kavlr{j}), ...
				     C(kmisr{j},kmisr{j}), ...
				     C(kavlr{j},kmisr{j}), n-1, optreg);

	  peff_ave = peff_ave + peff*pm/nmis;  % add up eff. number of variables
	  dofS     = dofC - peff;              % residual degrees of freedom

	  % inflation of residual covariance matrix
	  S        = inflation * S;
	  
	  % bias-corrected estimate of standard error in imputed values
	  Xerr(j, kmisr{j}) = dofC/dofS * sqrt(diag(S))';
	  
	 case 'iridge'
	  % one individual ridge regression per missing value in this record
	  [B, S, h, peff]   = iridge(C(kavlr{j},kavlr{j}), ...
				     C(kmisr{j},kmisr{j}), ...
				     C(kavlr{j},kmisr{j}), n-1, optreg);
	  
	  peff_ave = peff_ave + sum(peff)/nmis; % add up eff. number of variables
	  dofS     = dofC - peff;               % residual degrees of freedom

	  % inflation of residual covariance matrix
	  S        = inflation * S;
	  	  
	  % bias-corrected estimate of standard error in imputed values
	  Xerr(j, kmisr{j}) = ( dofC * sqrt(diag(S)) ./ dofS)';
	 case 'ttls'
	  % truncated total least squares with fixed truncation parameter
	  [B, S]   = pttls(V, d, kavlr{j}, kmisr{j}, trunc);
	  
	  dofS     = dofC - trunc;         % residual degrees of freedom
	  
	  % inflation of residual covariance matrix
	  S        = inflation * S;
	  	  
	  % bias-corrected estimate of standard error in imputed values
	  Xerr(j, kmisr{j}) = dofC/dofS * sqrt(diag(S))';
	  
	end
	
	% missing value estimates
	Xmis(j, kmisr{j})   = X(j, kavlr{j}) * B;
	
	% add up contribution from residual covariance matrices
	CovRes(kmisr{j}, kmisr{j}) = CovRes(kmisr{j}, kmisr{j}) + S;
      end	
    end                            % loop over records
     
    % rescale variables to original scaling 
    X          = X .* repmat(D', n, 1);
    Xerr       = Xerr .* repmat(D', n, 1);
    Xmis       = Xmis .* repmat(D', n, 1);
    C          = C .* repmat(D', p, 1) .* repmat(D, 1, p);
    CovRes     = CovRes .* repmat(D', p, 1) .* repmat(D, 1, p);

    % rms change of missing values
    dXmis      = norm(Xmis(indmis) - X(indmis)) / sqrt(nmis);
    
    % relative change of missing values
    nXmis_pre  = norm(X(indmis) + M(kmis)') / sqrt(nmis);    
    if nXmis_pre < eps
      rdXmis   = Inf;
    else
      rdXmis   = dXmis / nXmis_pre;
    end

    % update data matrix X
    X(indmis)  = Xmis(indmis);
    
    % re-center data and update mean
    [X, Mup]   = center(X);                  % re-center data
    M          = M + Mup;                    % updated mean vector
    
    % update covariance matrix estimate
    C          = (X'*X + CovRes)/dofC; 

    if dispon
      if Xcmp_given
	% imputed values in original scaling
	Xmis(indmis) = X(indmis) + M(kmis)'; 
	% relative error of imputed values (relative to values in Xcmp)
	dXmis        = norm( (Xmis(indmis)-Xcmp(indmis))./sXcmp(kmis)' ) ... 
	    / sqrt(nmis); 
	disp(sprintf('   \t%3i  \t %8.2e  \t    %10.3e     \t   %10.3e', ...
		     it, peff_ave, dXmis, rdXmis))
      
      else
	disp(sprintf('   \t%3i  \t %8.2e  \t%9.3e \t   %10.3e', ...
		     it, peff_ave, dXmis, rdXmis))
      end
    end                                      % display of diagnostics 
   
  end                                        % EM iteration

  % add mean to centered data matrix
  X  = X + repmat(M, n, 1);  
