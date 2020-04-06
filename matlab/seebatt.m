% ------- two recursion algorithms needed by the lambertbattin routine
function seebatt = seebatt( v );

% -------------------------  implementation   -------------------------
          c(1) =    0.2;
          c(2) =    9.0 /  35.0;
          c(3) =   16.0 /  63.0;
          c(4) =   25.0 /  99.0;
          c(5) =   36.0 / 143.0;
          c(6) =   49.0 / 195.0;
          c(7) =   64.0 / 255.0;
          c(8) =   81.0 / 323.0;
          c(9) =  100.0 / 399.0;
          c(10)=  121.0 / 483.0;
          c(11)=  144.0 / 575.0;
          c(12)=  169.0 / 675.0;
          c(13)=  196.0 / 783.0;
          c(14)=  225.0 / 899.0;
          c(15)=  256.0 /1023.0;
          c(16)=  289.0 /1155.0;
          c(17)=  324.0 /1295.0;
          c(18)=  361.0 /1443.0;
          c(19)=  400.0 /1599.0;
          c(20)=  441.0 /1763.0;
          c(21)=  484.0 /1935.0;
          sqrtopv= sqrt(1.0 + v);
          eta    = v / ( 1.0 + sqrtopv )^2;

          % ------------------- process forwards ----------------------
          delold = 1.0;
          termold= c(1);   % * eta
          sum1   = termold;
          i= 2; 
          while ((i <= 21) && (abs(termold) > 0.00000001 ))
              del  = 1.0 / ( 1.0 + c(i)*eta*delold );
              term = termold * (del - 1.0);
              sum1 = sum1 + term;
              i    = i + 1;
              delold = del;
              termold= term;
          end

          seebatt= 1.0/ ((1.0/(8.0*(1.0+sqrtopv))) * ( 3.0 + sum1 / ( 1.0+eta*sum1 ) ) );

          c(1) =    9.0 /   7.0;
          c(2) =   16.0 /  63.0;
          c(3) =   25.0 /  99.0;
          c(4) =   36.0 / 143.0;
          c(5) =   49.0 / 195.0;
          c(6) =   64.0 / 255.0;
          c(7) =   81.0 / 323.0;
          c(8) =  100.0 / 399.0;
          c(9) =  121.0 / 483.0;
          c(10)=  144.0 / 575.0;
          c(11)=  169.0 / 675.0;
          c(12)=  196.0 / 783.0;
          c(13)=  225.0 / 899.0;
          c(14)=  256.0 /1023.0;
          c(15)=  289.0 /1155.0;
          c(16)=  324.0 /1295.0;
          c(17)=  361.0 /1443.0;
          c(18)=  400.0 /1599.0;
          c(19)=  441.0 /1763.0;
          c(20)=  484.0 /1935.0;

          
          ktr   = 20;
          sum2  = 0.0;   
          term2 = 1.0 + c(ktr)*eta;          
          for i = 1 : ktr - 2
               sum2  = c(ktr-i)*eta / term2;     
               term2 = 1.0 + sum2;
          end 
          
          seebatt = 8.0*(1.0 + sqrtopv) / ...
             (3.0 + ...
                (1.0 / ...
                   (5.0 + eta + ((9.0/7.0)*eta/term2 ) ) ) );
          
          