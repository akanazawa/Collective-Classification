function [fim] = fbRun(im)
% function [fim] = fbRun(fb,im)
%
% Run a filterbank on an image with reflected boundary conditions.
%
% See also fbCreate,padReflect.
%
% David R. Martin <dmartin@eecs.berkeley.edu>
% March 2003

%% AJ: modified just so that fb is not a parameter but a constant
load fb

% find the max filter size
maxsz = max(size(fb{1}));
for i = 1:numel(fb),
  maxsz = max(maxsz,max(size(fb{i})));
end

% pad the image 
r = floor(maxsz/2);
impad = padReflect(im,r);

% run the filterbank on the padded image, and crop the result back
% to the original image size
%fim = cell(size(fb));
fim = zeros(numel(fb),size(im,1)*size(im,2),'single');
for i = 1:numel(fb),
  if size(fb{i},1)<50,
    f = conv2(impad,fb{i},'same');
  else
    f = fftconv2(impad,fb{i});
  end
  f = f(r+1:end-r,r+1:end-r);
  fim(i,:) = f(:);
end
