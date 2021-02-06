function result=checkVEall(attrValue)

idx=find(attrValue=='_');

for i=1:8*3
    if i==1
        result(1)=checkNum(attrValue(1:idx(i)-1));
    else
        if i==24
        result(24)=checkNum(attrValue(idx(23)+1:end));
        else
        result(i)=checkNum(attrValue(idx(i-1)+1:idx(i)-1));
        end
    end
end
result=result';

% VE_all		x0_y0_matrix0_I0_PW0_Enable0_RT0_FT_0_
% 			x1_y1_matrix1_I1_PW1_Enable1_RT1_FT_1_
% 			x2_y2_matrix2_I2_PW2_Enable2_RT2_FT_2_
% 			x3_y3_matrix3_I0_PW3_Enable0_RT3_FT_3_
% 			x4_y4_matrix4_I0_PW4_Enable0_RT4_FT_4
% 			
% 			//int_int_int_int_int_int_int_int_int_
% 			  int_int_int_int_int_int_int_int_int_
% 			  int_int_int_int_int_int_int_int_int_
% 			  int_int_int_int_int_int_int_int_int_
% 			  int_int_int_int_int_int_int_int_int
			