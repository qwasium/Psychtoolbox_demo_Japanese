function imgStruct = readImgFromDir(directory, imgCondition, imgStruct, filetype)
    %{
    Read all images in a provided directory. 
    
    MATLAB R2023a Ubuntu22
    Sep2023 SK
    
    Parameters
    ----------
    directory : str or char
        directory path to search for images
        example: '/home/hoge/piyo/'
    imgCondition : any, but keep it simple
        condition of image, same value used within directory
        example: 1==target, 0==non-target
    imgStruct : structure
        if it's not the first time calling the function, you can provide
        imgStruct to add images to it.
    filetype : cell of str/char
        cell with all valid file extentions.
        default: {'.jpg', '.png'}

    Returns
    -------
    imgStruct : structure
        If imgStruct is provided, apped and return.
        imgID   : read in order,   example : 3  
        imgName : image name,      example : '2001.jpg'
        imgMat  : image matrix,    example : matrix of 1080*1920*3 uint8
        imgSize : image size,      example : [1080, 1920, 3]
        imgCond : image condition, example : 0(defined by argument)
        
    Note
    ----
    In order to index imgStruct with img name or ID,  use something like this:

        ```matlab

	    # index by file name
            imgFileName = 'hoge.jpg';
            imgMatrix = imgStruct(strcmp({imgStruct.imgName}, imgFileName)).imgMat;
    
    	    # index by image ID
            imgFileID = 2;
            imgName = imgStruct([imgStruct.imgID]==imgFileID).imgName

        ```

    %}

    % R2019b or newer
    arguments
        directory
        imgCondition
        imgStruct     struct = struct
        filetype (1, :) cell = {'.jpg', '.JPG', '.png', '.PNG'}
    end

    % get next image ID
    if isempty(fieldnames(imgStruct))
        % imgStruct was not provided and empty
        ID = 1;
    else
        % imgStruct was provided
        ID = size(imgStruct, 2) + 1;
    end

    % make filetype into a filter pattern for regex
    filetype = cellfun(@(x) append('\', x, '$'), filetype, 'UniformOutput', false);

    % get list of files of directory
    cd(directory)
    dirList = dir(directory);
    dirList = dirList(~cellfun('isempty', {dirList.date})); % date==empty is invalid

    for i = 3:length(dirList) % always skip first two; '.' and '..'
        
        % skip directories
        if dirList(i).isdir
            continue
        end

        currentfilename = dirList(i).name;

        % skip if file extention is not included in filetype
        for j = 1:length(filetype)
            if isempty(regexp(currentfilename, filetype(j), 'once'))
                warning('skipping invalid');
                continue
            end
        end

        % read in image
        currentimage = imread(currentfilename);

        % save values
        imgStruct(ID).imgID   = ID;
        imgStruct(ID).imgName = currentfilename;
        imgStruct(ID).imgMat  = currentimage;
        imgStruct(ID).imgSize = size(currentimage);
        imgStruct(ID).imgCond = imgCondition;

        ID = ID + 1;
    end
    
    % garbage collection to conserve RAM
    clear currentimage

    % remove empty from imgStruct
    imgStruct = imgStruct(~cellfun('isempty', {imgStruct.imgMat}));
end % function
