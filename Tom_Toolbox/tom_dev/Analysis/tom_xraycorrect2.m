function I=tom_xraycorrect2(varargin)
%TOM_XRAYCORRECT   Corrects X-Ray defects on EM Images (2-D)
%   This function finds the coordinates of the X-Ray infected pixels
%   and corrects them, by applying a mask. The mean value of the pixels
%   contained in the mask is calculated and the value of the affected
%   pixel is replaced by this mean value. If the input image has no
%   X-Ray defects then the output is the same as the input.
% 
%PARAMETERS
%
%  INPUT
%   varargin            ...
%  
%  OUTPUT
%   I           		...
%
%  Examples
% ----------
%
%   J=TOM_XRAYCORRECT(I) returns the corrected image J by using a 5x5
%                        neighborhood for the calculation of the mean
%                        value
%
%   J=TOM_XRAYCORRECT(I,s) returns the correctes image J by using a
%                          (2*s+1)x(2*s+1) neighborhood for the
%                          calculation of the mean value
%
%
%REFERENCES
%
%   See also : TOM_LIMIT, TOM_SORTSERIES, TOM_SETMARK 
%
%   created by AL 10/20/02
%   updated 09/03/04
%
%   Nickell et al., 'TOM software toolbox: acquisition and analysis for electron tomography',
%   Journal of Structural Biology, 149 (2005), 227-234.
%
%   Copyright (c) 2004-2007
%   TOM toolbox for Electron Tomography
%   Max-Planck-Institute of Biochemistry
%   Dept. Molecular Structural Biology
%   82152 Martinsried, Germany
%   http://www.biochem.mpg.de/tom

if nargin<1
    error('Not enough Input Arguments');
    return;
end
if nargin==1
    J=varargin{1};
    I=J;
    s=2;
    thr=-10000;
end

if nargin==2
    J=varargin{1};
    I=J;
    s=varargin{2};
    thr=-10000;
end;

if nargin==3
    J=varargin{1};
    I=J;
    s=varargin{2};
    thr=varargin{3};
end;

if nargin > 4    
    error('Too many input Arguments');
    return;
end
if size(J,3) > 1
    disp('Skipping 3D data');
    return;
end

d=std2(J);
meanimg=mean(mean(J));

if (thr==-10000)
    [x,y]=find(J>(meanimg+4.6.*d) | J<(meanimg-4.6*d)); % factor 10 added by SN
else
    [x,y]=find(J>thr); %threshold 4 frames
end;
if isempty(x)
    return;
else
    for i=1:size(x,1)
        if ((x(i)-s > 0) && (y(i)-s > 0) && (x(i)+s <= size(I,1)) ... % bug fixed FF
                && (y(i)+s <= size(I,2)) )
            if (thr==-10000)
                I(x(i),y(i))=mask(I,x(i),y(i),d,meanimg,s,5);
            else
                I(x(i),y(i))=mask4thr(I,x(i),y(i),s,thr,meanimg);
            end;
        else
            I(x(i),y(i))=mean(mean(I));
        end;
    end
end
if size(x,1)>0
    %disp(['values outside range found: ' num2str(size(x,1))]); %changed by SN
end;


%****** SubFunction mask ***********

function c=mask(A,xcoor,ycoor,dev,meanimg,s,n_dev)

[xdim ydim]=size(A);
a=A(xcoor-s:xcoor+s,ycoor-s:ycoor+s);
t=find((a>(meanimg+(n_dev.*dev)) | a<(meanimg-(n_dev.*dev))));
good_t=find((a<=(meanimg+(n_dev.*dev))) & (a>=(meanimg-(n_dev.*dev))));

if isempty(t)
    c=mean(a(:));
elseif (size(a,1)*size(a,2) == size(t,1))%bug fixed FF
    c=meanimg;
else
    c=mean(a(good_t));
end

function c=mask4thr(A,xcoor,ycoor,s,thr,meanimg)

[xdim,ydim]=size(A);
a=A(xcoor-s:xcoor+s,ycoor-s:ycoor+s);
t=find(a>=thr);
good_t=find((a<thr));

if (size(a,1)*size(a,2) == size(t,1))%bug fixed FF
    c=meanimg;
else
    c=mean(a(good_t));
end;

 
