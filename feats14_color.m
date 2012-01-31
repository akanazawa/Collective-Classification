function [m,s,h]=feats14_color(mask,I)
% Compute Color Features for a segment in an Image
% Tomasz Malisiewicz (tomasz@cmu.edu)
HISTDELTA = 0:.1:1;

Ir = I(:,:,1);
Ig = I(:,:,2);
Ib = I(:,:,3);

npix = sum(mask(:));

%handle null mask
if sum(mask(:))==0
  fprintf(1,'need to write null mask handler here\n');
  keyboard
end

    
h = [hist(Ir(mask),HISTDELTA) ...
     hist(Ig(mask),HISTDELTA) ...
     hist(Ib(mask),HISTDELTA)]'/npix;

m = [mean(Ir(mask)); ... 
     mean(Ig(mask)); ...
     mean(Ib(mask))];

s = [std(Ir(mask)); ...
     std(Ig(mask)); ...
     std(Ib(mask))];


