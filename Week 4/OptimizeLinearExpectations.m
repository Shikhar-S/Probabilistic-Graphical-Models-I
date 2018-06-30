% Copyright (C) Daphne Koller, Stanford University, 2012

function [MEU OptimalDecisionRule] = OptimizeLinearExpectations( I )
  % Inputs: An influence diagram I with a single decision node and one or more utility nodes.
  %         I.RandomFactors = list of factors for each random variable.  These are CPDs, with
  %              the child variable = D.var(1)
  %         I.DecisionFactors = factor for the decision node.
  %         I.UtilityFactors = list of factors representing conditional utilities.
  % Return value: the maximum expected utility of I and an optimal decision rule 
  % (represented again as a factor) that yields that expected utility.
  % You may assume that there is a unique optimal decision.
  %
  % This is similar to OptimizeMEU except that we will have to account for
  % multiple utility factors.  We will do this by calculating the expected
  % utility factors and combining them, then optimizing with respect to that
  % combined expected utility factor.  
  MEU = [];
  OptimalDecisionRule = [];
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %
  % YOUR CODE HERE
  %
  % A decision rule for D assigns, for each joint assignment to D's parents, 
  % probability 1 to the best option from the EUF for that joint assignment 
  % to D's parents, and 0 otherwise.  Note that when D has no parents, it is
  % a degenerate case we can handle separately for convenience.
  %
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  I_temp=I;
  I_temp.UtilityFactors=I.UtilityFactors(1);
  EUF=CalculateExpectedUtilityFactor(I_temp);
  for i=2:length(I.UtilityFactors)
    I_temp.UtilityFactors=I.UtilityFactors(i);
    EUF=FactorSum(EUF,CalculateExpectedUtilityFactor(I_temp));
  end


  D=I.DecisionFactors(1);
  EU=0;
  delta=[];
  decision_var=D.var(1);
  decision_var_pos=find(EUF.var==decision_var);

  if(length(D.var)==1)%no parents
      mx=EUF.val(1);
      pos=1;
      for i=2:EUF.card(1)
        if(mx<EUF.val(i))
          mx=EUF.val(i);
          pos=i;
        end
      end
      value=zeros(1,EUF.card);
      value(pos)=1;
      EU+=mx;
      delta=struct('var',EUF.var,'card',EUF.card,'val',value);
  else
      parents_card=[EUF.card(1:decision_var_pos-1),EUF.card(decision_var_pos+1:end)];
      delta=struct('var',EUF.var,'card',EUF.card,'val',zeros(1,prod(EUF.card)));
      for i=1:prod(parents_card)
        Assignment=IndexToAssignment(i,parents_card);
        completeAssignment=[Assignment(1:decision_var_pos-1),1,Assignment(decision_var_pos:end)];
        mx_pos=AssignmentToIndex(completeAssignment,EUF.card);
        mx=EUF.val(mx_pos);
        for decision=2:D.card(1)
          completeAssignment=[Assignment(1:decision_var_pos-1),decision,Assignment(decision_var_pos:end)];
          idx=AssignmentToIndex(completeAssignment,EUF.card);
          if(EUF.val(idx)>mx)
            mx=EUF.val(idx);
            mx_pos=idx;
          end
        end
        delta.val(mx_pos)=1;
        EU+=mx;
      end
  end
    MEU=EU;
    OptimalDecisionRule=delta;
end
