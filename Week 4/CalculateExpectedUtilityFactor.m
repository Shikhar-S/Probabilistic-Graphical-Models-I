% Copyright (C) Daphne Koller, Stanford University, 2012

function EUF = CalculateExpectedUtilityFactor( I )

  % Inputs: An influence diagram I with a single decision node and a single utility node.
  %         I.RandomFactors = list of factors for each random variable.  These are CPDs, with
  %              the child variable = D.var(1)
  %         I.DecisionFactors = factor for the decision node.
  %         I.UtilityFactors = list of factors representing conditional utilities.
  % Return value: A factor over the scope of the decision rule D from I that
  % gives the conditional utility given each assignment for D.var
  %
  % Note - We assume I has a single decision node and utility node.
  EUF = [];
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %
  % YOUR CODE HERE...
  %
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  

  scope=unique([I.DecisionFactors(:).var]);
  fullscope=unique([I.RandomFactors(:).var]);
  fullscope=union(fullscope,I.UtilityFactors.var);
  marginalised=VariableElimination([I.RandomFactors I.UtilityFactors],[setdiff(fullscope,scope)]);

  if(length(marginalised)>1)
    G=marginalised(1);
    for i=2:length(marginalised)
      G=FactorProduct(G,marginalised(i));
    end
    marginalised=G;
  end
  EUF=marginalised;
end  
