function [f1,f2,f3,f4,f5]=feats14_texture(mask,textons)
% Compute texture features over segment
% Tomasz Malisiewicz (tomasz@cmu.edu)
texturefeat = get_radial_feats(mask,textons);
f1 = texturefeat((1:100) + 000);
f2 = texturefeat((1:100) + 100);
f3 = texturefeat((1:100) + 200);
f4 = texturefeat((1:100) + 300);
f5 = texturefeat((1:100) + 400);

