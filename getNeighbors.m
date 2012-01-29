function [AdjM] = getNeighbors(L, R)
%%%%%%%%%%
% getNeighbors.m
%   This function simply scans through pixels in the image and examine
%   pixel neighbors, incrementing the corresponding entry in the adjacency
%   matrix
%  - This version ignores vertical neighbors in the right most column
%    of the image.
%
% INPUT: L - a H by W matrix of super segmented image mask
% OUTPUT: R by R adjacency matrix
%
%%%%%%%%%%

[M, N] = size(L);
AdjM = zeros(R);
for m = 1:M
    for n = 1:(N-1)
        cL = L(m,n) + 1; %label of the current pixel
                
        % Upper Right pixel
        if (m > 1) 
            nL = L(m-1,n+1) + 1;
            if (cL ~= nL)
                AdjM(cL, nL) = AdjM(cL, nL) + 1;
            end
        end
        
        % Right pixel
        nL = L(m,n+1) + 1;
        if cL ~= nL
            AdjM(cL, nL) = AdjM(cL, nL) + 1;
        end

        if (m < M)
            % Lower Right pixel
            nL = L(m+1,n+1) + 1;
            if cL ~= nL
                AdjM(cL, nL) = AdjM(cL, nL) + 1;
            end

            % Lower pixel
            nL = L(m+1,n) + 1;
            if cL ~= nL
                AdjM(cL, nL) = AdjM(cL, nL) + 1;
            end
        end
    end
end

AdjM = AdjM' + AdjM;

end

