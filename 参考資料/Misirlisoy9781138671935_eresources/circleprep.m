function [circlecoordinates] = circleprep(circlesize,center)

circlecoordinates = [center(1)-circlesize, center(2)-circlesize,...
    center(1)+circlesize, center(2)+circlesize];
    
end