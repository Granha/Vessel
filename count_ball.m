function ball_count=count_ball(im, num_iteration)

test = zeros(8);

[M, N] = size(im);

ball_count = zeros(M,N);

for k = 1:(num_iteration*M*N)

  m = round(1 + (M-1)*rand);
  n = round(1 + (N-1)*rand);

  curr_pixel = im(m,n);
  
  if curr_pixel ~= 0
    ball_count(m,n) = ball_count(m,n) + 1;

    while (true)
    
      % find direction
      test(1) = (m-1 ~= 0   && im(m-1,n) < curr_pixel);
      if test(1)
        test(1) = im(m-1,n);
      end
      test(2) = (m+1 ~= M+1 && im(m+1,n) < curr_pixel);
      if test(2)
        test(2) = im(m+1,n);
      end
      test(3) = (n-1 ~= 0   && im(m,n-1) < curr_pixel);
      if test(3)
        test(3) = im(m,n-1);
      end
      test(4) = (n+1 ~= N+1 && im(m,n+1) < curr_pixel);
      if test(4)
        test(4) = im(m,n+1);
      end
      
      test(5) = (m-1 ~= 0   && n-1 ~= 0   && im(m-1,n-1) < curr_pixel);
      if test(5)
        test(5) = im(m-1,n-1);
      end
      test(6) = (m+1 ~= M+1 && n-1 ~= 0   && im(m+1,n-1) < curr_pixel);
      if test(6)
        test(6) = im(m+1,n-1);
      end
      test(7) = (m-1 ~= 0   && n+1 ~= N+1 && im(m-1,n+1) < curr_pixel);
      if test(7)
        test(7) = im(m-1,n+1);
      end
      test(8) = (m+1 ~= M+1 && n+1 ~= N+1 && im(m+1,n+1) < curr_pixel);
      if test(8)
        test(8) = im(m+1,n+1);
      end
      
      [min_test, index] = min(test(:));

      % end loop
      if min_test >= 0
       break;
      end
      
      % move
      switch index
        case 1
	  m = m-1;
	case 2
	  m = m+1;
	case 3
	  n = n-1;
	case 4
	  n = n+1;
	case 5
	  m = m-1;
          n = n-1;
	case 6
	  m = m+1;
	  n = n-1;
	case 7
	  m = m-1;
	  n = n+1;
        case 8
	  m = m+1;
	  n = n+1;
      end

      curr_pixel = im(m,n);
      ball_count(m,n) = ball_count(m,n) + 1;    
    end
  end
 end
end