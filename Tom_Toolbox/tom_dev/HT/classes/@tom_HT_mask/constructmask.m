function this = constructmask(this)


%params(i).name = [circle,rectangle,polygon,freehand,magic wand]
%params(i).vals = 
%                   circle: centerx,centery,radius,sigma
%                   rectangle:  leftupperx, leftuppery,width,height
%                   polygon:    [x,y]*n
%                   freehand:   matrix
%                   magic wand: refx,refy,tolerance,neighbourhood,matrix
%                   gaussian:   centerx, centery, sigma
%                   raised_cosine:   centerx, centery, R1, R2

this.mask = zeros(this.size.x,this.size.y,'single');
if ~isempty(fieldnames(this.params))
    for idx=1:size(this.params,2)
        switch lower(this.params(idx).name)
            case 'circle'
                this.mask = this.mask + tom_sphere([this.size.x this.size.y], this.params(idx).vals(3) ,this.params(idx).vals(4),[this.params(idx).vals(1) this.params(idx).vals(2)]);
            case 'rectangle'
                this.mask =  this.mask + tom_rectangle([this.size.x this.size.y],this.params(idx).vals(1),this.params(idx).vals(2),this.params(idx).vals(3),this.params(idx).vals(4));
            case 'polygon'
            case 'freehand'
                this.mask = this.mask + this(idx).vals;
            case 'magic wand'
                this.mask = this.mask + this(idx).vals{5};
            case 'gaussian'
                this.mask = this.mask + tom_xmipp_mask([this.size.x this.size.y],'gaussian',[this.params(idx).vals{1} this.params(idx).vals{2}],this.params(idx).vals{3});
            case 'raised_cosine'
                 this.mask = this.mask + tom_xmipp_mask([this.size.x this.size.y],'raised_cosine',[this.params(idx).vals{1} this.params(idx).vals{2}],this.params(idx).vals{3},this.params(idx).vals{4});
        end

        this.mask(this.mask>1) = 1;
    end
end

