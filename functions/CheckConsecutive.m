function result=CheckConsecutive(q)

a=diff(q);

b=find([a inf]>1);

c=diff([0 b]); %length of the sequences

d=cumsum(c); %endpoints of the sequences


