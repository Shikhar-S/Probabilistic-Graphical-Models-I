function factors = ChooseTopSimilarityFactors (allFactors, F)
% This function chooses the similarity factors with the highest similarity
% out of all the possibilities.
%
% Input:
%   allFactors: An array of all the similarity factors.
%   F: The number of factors to select.
%
% Output:
%   factors: The F factors out of allFactors for which the similarity score
%     is highest.
%
% Hint: Recall that the similarity score for two images will be in every
%   factor table entry (for those two images' factor) where they are
%   assigned the same character value.
%
% Copyright (C) Daphne Koller, Stanford University, 2012

% If there are fewer than F factors total, just return all of them.
if (length(allFactors) <= F)
    factors = allFactors;
    return;
end
Values=[];
% Your code here:
for i=1:length(allFactors)
	Values=[Values,allFactors(i).val(1)];
end

[value,value_i]=sort(Values,'descend');
top_value_idx=value_i(1:F);
factors=allFactors(top_value_idx);
end

