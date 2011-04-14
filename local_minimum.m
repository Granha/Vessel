%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Given a 2-D curve, find the local minima
%
% @param:
% curve  - input 2-D curve
% factor - neighboor tolerance (5% default)
% connexity - 0 => 4 connexity
%             1 => 8 connexity (default)
% @return:
% binnary image, 1 local maximum and
% 0 otherwise
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function minimum=local_minimum(curve, factor, connexity)

if nargin < 3
  connexity = 1; % 8 connexity
end

if nargin < 2
  factor = 0.05; % 5% tolerance
end

[M N] = size(curve);			   
minimum = zeros(M,N);

test = zeros(8, 1);
tolerance = zeros(8, 1);
    
coeff = 1+factor;

for m = 1:M
  for n = 1:N

    curr_pixel = curve(m,n);
    tolerance = zeros(8, 1);

    if curr_pixel ~= 0

      test(1) = (m-1 == 0   || curve(m-1,n) >= curr_pixel || curve(m-1,n) >= coeff*curr_pixel);
      if m-1 ~= 0 && curve(m-1,n) < curr_pixel
	tolerance(1) = 1;
      end
      test(2) = (m+1 == M+1 || curve(m+1,n) >= curr_pixel || curve(m+1,n) >= coeff*curr_pixel);
      if m+1 ~= M+1 && curve(m+1,n) < curr_pixel
	tolerance(2) = 1;
      end
      test(3) = (n-1 == 0   || curve(m,n-1) >= curr_pixel || curve(m,n-1) >= coeff*curr_pixel);
      if n-1 ~= 0 && curve(m,n-1) < curr_pixel
	tolerance(3) = 1;
      end
      test(4) = (n+1 == N+1 || curve(m,n+1) >= curr_pixel || curve(m,n+1) >= coeff*curr_pixel);
      if n+1 ~= N+1 && curve(m,n+1) < curr_pixel
	tolerance(4) = 1;
      end

      test(5) = (m-1 == 0   || n-1 == 0   || curve(m-1,n-1) >= curr_pixel || curve(m-1,n-1) >= coeff*curr_pixel);
      if m-1 ~= 0  && n-1 ~= 0 && curve(m-1,n-1) < curr_pixel
	tolerance(5) = 1;
      end

      test(6) = (m+1 == M+1 || n-1 == 0   || curve(m+1,n-1) >= curr_pixel || curve(m+1,n-1) >= coeff*curr_pixel);
      if m+1 ~= M+1  && n-1 ~= 0 && curve(m+1,n-1) < curr_pixel
	tolerance(6) = 1;
      end

      test(7) = (m-1 == 0   || n+1 == N+1 || curve(m-1,n+1) >= curr_pixel || curve(m-1,n+1) >= coeff*curr_pixel);
      if m-1 ~= 0  && n+1 ~= N+1 && curve(m-1,n+1) < curr_pixel
	tolerance(7) = 1;
      end

      test(8) = (m+1 == M+1 || n+1 == N+1 || curve(m+1,n+1) >= curr_pixel || curve(m+1,n+1) >= coeff*curr_pixel);
      if m+1 ~= M+1  && n+1 ~= N+1 && curve(m+1,n+1) < curr_pixel
	tolerance(8) = 1;
      end

      % the current pixel must have an absolute value greather than half of its neighbours

      if connexity == 0 % 4 connexity
	if sum(test(1:4)) == 4 && sum(tolerance(1:4)) <= 2
          minimum(m,n) = 1;
	end
      else % 8 connexity
	if sum(test(1:8)) == 8 && sum(tolerance(1:8)) <= 1
          minimum(m,n) = 1;
	end
      end
    end
  end
end

end
