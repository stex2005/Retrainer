function result=CheckMaxConsecutive(input)

input = sort(input);

a=diff(input);

b=find([a inf]>1);

result=max(diff([0 b])); %length of the sequences




