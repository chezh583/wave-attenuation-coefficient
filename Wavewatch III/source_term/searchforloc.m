function [I,J]=searchforloc(arg_lat,arg_lon,latgrid,longrid)
  dist2=sum(bsxfun(@minus,cat(3,arg_lat,arg_lon),cat(3,latgrid,longrid)).^2,3);
  [I,J]=find(dist2==min(dist2(:)));
end
