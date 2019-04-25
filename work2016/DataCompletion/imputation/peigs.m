function [V, d, r] = peigs(A, rmax)
%PEIGS   Finds positive eigenvalues and corresponding eigenvectors. 
%  
%    [V, d, r] = PEIGS(A, rmax) determines the positive eigenvalues d
%    and corresponding eigenvectors V of a matrix A. The input
%    parameter rmax is an upper bound on the number of positive
%    eigenvalues of A, and the output r is an estimate of the actual
%    number of positive eigenvalues of A. The eigenvalues are returned
%    as the vector d(1:r). The eigenvectors are returned as the
%    columns of the matrix V(:, 1:r).
%
%    PEIGS calls the function EIGS to compute the first rmax
%    eigenpairs of A by Arnoldi iterations. Eigenpairs corresponding
%    eigenvalues that are nearly zero or less than zero are
%    subsequently discarded.
%
%    PEIGS is only efficient if A is strongly rank-deficient with
%    only a small number of positive eigenvalues, so that rmax <<
%    min(size(A)). If A has full rank, EIG should be used in place of
%    PEIGS.
%
%    See also: EIGS.

  error(nargchk(2, 2, nargin))                    % check number of input arguments 
  [m, n]  = size(A);
 
  if rmax > min(m,n)
    rmax  = min(m,n);                             % rank cannot exceed size of A 
  end
      
  % get first rmax eigenvectors of A
  warning off
  %eigsopt.disp = 0;                               % do not display eigenvalues
  [V, d]       = eigs(A, rmax, 'lm'); %, eigsopt);
  warning on
  
  % output of eigs differs in different Matlab versions
  if prod(size(d)) > rmax
    d          = diag(d);                         % ensure d is vector
  end

  % ensure that eigenvalues are monotonically decreasing
  [d, I]       = sort(d, 'descend');
  V            = V(:, I);
  
  % estimate number of positive eigenvalues of A
  d_min        = max(d) * max(m,n) * eps; 
  r            = sum(d > d_min);
				 
  % discard eigenpairs with eigenvalues that are close to or less than zero
  d            = d(1:r);
  V            = V(:, 1:r);
  d            = d(:);				  % ensure d is column vector
