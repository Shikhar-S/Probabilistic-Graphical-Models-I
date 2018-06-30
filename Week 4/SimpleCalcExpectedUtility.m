% Copyright (C) Daphne Koller, Stanford University, 2012

function EU = SimpleCalcExpectedUtility(I)

  % Inputs: An influence diagram, I (as described in the writeup).
  %         I.RandomFactors = list of factors for each random variable.  These are CPDs, with
  %              the child variable = D.var(1)
  %         I.DecisionFactors = factor for the decision node.
  %         I.UtilityFactors = list of factors representing conditional utilities.
  % Return Value: the expected utility of I
  % Given a fully instantiated influence diagram with a single utility node and decision node,
  % calculate and return the expected utility.  Note - assumes that the decision rule for the 
  % decision node is fully assigned.

  % In this function, we assume there is only one utility node.
  F = [I.RandomFactors I.DecisionFactors];
  U = I.UtilityFactors(1);
  EU = [];
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %
  % YOUR CODE HERE
  %
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  allvars=unique([I.RandomFactors(:).var]);
  allvars=union(allvars,I.DecisionFactors.var);
  elim=unique([I.UtilityFactors(:).var]);

  eliminate=setdiff(allvars,elim);

  marginalized=VariableElimination(F,eliminate);
  
  if(length(marginalized)>1) %if there is no variable to be eliminated the fn returns wrong output.
    G=marginalized(1);
    for i=2:length(marginalized)
      G=FactorProduct(G,marginalized(i));
    end
    marginalized=G;
  end
  
  H=FactorProduct(marginalized,U);
  EU=sum(H.val);
end
