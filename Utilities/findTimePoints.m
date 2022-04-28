function STIM = findTimePoints(fullFileName)

okparadigms = {...
    'bmcBRFS'       '.gbmcBRFSgrating_di'};


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% sort filelist in time, check for BR files on disk
clear T I
NS_header = openNSx([fullFileName '.ns2'],'noread');
T = datenum(NS_header.MetaTags.DateTime,'dd-mmm-yyyy HH:MM:SS');
filetime = datestr(T');
clear I NS_header filename T

% determin paradigm, check for grating text files on disk
clear paradigm extension
[~,BRdatafile,~] = fileparts(fullFileName);

paradigm = BRdatafile(10:end-3);

clear BRdatafile

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fpath            = fileparts(fullFileName);
STIM.header      = fpath(end-7:end);

obs = 0;
    
    % NEV
    clear NEV Fs
    NEV = openNEV(strcat(fullFileName,'.nev'),'noread','nosave','nomat');
    Fs = double(NEV.MetaTags.TimeRes);
    
    % Event Codes from NEV
    clear EventCodes EventSampels pEvC pEvT
    EventCodes = NEV.Data.SerialDigitalIO.UnparsedData - 128;
    EventSampels = NEV.Data.SerialDigitalIO.TimeStamp;
    [pEvC, pEvT] = parsEventCodesML(EventCodes,EventSampels);
    
    % Standard bmcBRFS trial output
    %      9
    %      9
    %      9
    %    117
    %    117
    %    117
    %     35 = fix spot on              on run_Scene(scene1,[35,11])
    %     11 = start wait fication      on run_Scene(scene1,[35,11])
    %      8 = fixation occurs          on "else" of "if ~wth1.Success" so... on wth1.Success = true? 
    %     23 = "taskObject-1 ON"        on running the second scene
    %     24 = "task object 1 OFF"      ??? Marks end of first scene? Runs from "else" under "if == error_type"
    %     13 = photo diode blink        on runing the third scene
    %     24 = task object 1 off       I'm starting to think this indicatess the end of the scene time 
    %     25 = task object 2 on
    %     26 = task object 2 off %% This is a reliable way to identify the end of a full trial event  
    %     36 = run scene scene 5 - event code for fix cross OFF. Please note that this event code occurs if the monkey does not finish the trial 
    %     96 = good monkey, reward 1
    %     96 = good monkey, reward 2
    %     18
    %     18
    %     18
    
    
    
    %Other important misc. gratintg stuff happenes here....
    % stimulus text file
    clear grating
    grating = readgBmcBRFSGrating([fullFileName '.gbmcBRFSgrating_di']);
    grating = orderfields(grating);
    % check that all is good between NEV and grating text file;
    n = length(grating.trial);

  
    % sort trials , get TPs
    for t = 1:length(pEvC)
        % Pull out trials where fixation was broken but the full monocular
        % presentation was completed. We can use these trials for their
        % monocular data in the first 800ms. To do this we need to look for
        % the photo diode trigger event code 13 (at 750ms) or the second
        % event code of 24, which would be the end of the SOA period
        % look for photo diode blink event code but no good monkey reward.
        % i.e. look for 13 (pt blink) and no 96 (no reward given)
        if any(pEvC{t} == 13) && ~any(pEvC{t} == 96) && ((sum(pEvC{t} == 24)) == 2) %2 values of 24 means that we get through the end of the photo diode blink
            obs = obs + 1;
            
                STIM.('task'){obs,:}  =  paradigm;
                STIM.('trl')(obs,:)   = t;
            STIM.('first800')(obs,:)     = true;
            STIM.('fullTrial')(obs,:)  = false;
            STIM.('reward')(obs,:)     = false;

            % trigger points
            stimon  =  pEvC{t} == 23;
            stimoff =  pEvC{t} == 24; % we are only going to be interested in the second 24 event code here... hang on until we get there. (it will signify the end of the photo diode blink interval)
      
            st = double(pEvT{t}(stimon));
            en = double(pEvT{t}(stimoff));

            STIM.tp_ec(obs,:)    = [23 24]; % see lines 435-6
            STIM.tp_sp(obs,:)     = [st en(2)]; % Here we only pull out the second event code.
% %             STIM.allEventCodes{obs,:} = pEvC{t};
% %             STIM.allTimePoints{obs,:} = pEvT{t};


            % write STIM features
            if t == 1
                STIM.date = STIM.header;
                STIM.startRow = grating.startRow;
                STIM.endRow = grating.endRow;
                STIM.filename = grating.filename;
            end
            fields = fieldnames(grating);
            for f = 1:length(fields)
                if any(strcmp(fields{f},{'endRow','filename','startRow','header'})) 
                    continue
                else
                    STIM.(fields{f})(obs,:) = (grating.(fields{f})(t,:));
                end
            end

        end

        % For complete trials - make sure a photo diode blink happened, the
        % second task object comes off the screne, and juice reward was
        % delivered (13, 26, and 96 pEvC respectivly)
        if any(pEvC{t} == 13) && any(pEvC{t} == 26) && any(pEvC{t} == 96)
            % pull out the first 800ms of soa
            obs = obs + 1;

                STIM.('task'){obs,:}  =  paradigm;
                STIM.('trl')(obs,:)   = t;
            STIM.('first800')(obs,:)     = true; 
            STIM.('fullTrial')(obs,:)  = true;
            STIM.('reward')(obs,:)     = true;

            % trigger points
            stimon  =  pEvC{t} == 23;
            stimoff =  pEvC{t} == 24; % we are only going to be interested in the second 24 event code here... hang on until we get there. (it will signify the end of the photo diode blink interval)

            st = double(pEvT{t}(stimon));
            en = double(pEvT{t}(stimoff));

            STIM.tp_ec(obs,:)    = [23 24]; 
            STIM.tp_sp(obs,:)     = [st en(2)]; % Here we only pull out the second event code.
% %             STIM.allEventCodes(obs,:) = pEvC{t};
% %             STIM.allTimePoints(obs,:) = pEvT{t};

            % write STIM features
            if t == 1
                STIM.date = STIM.header;
                STIM.startRow = grating.startRow;
                STIM.endRow = grating.endRow;
                STIM.filename = grating.filename;
            end
            fields = fieldnames(grating);
            for f = 1:length(fields)
                if any(strcmp(fields{f},{'endRow','filename','startRow','header'})) 
                    continue
                else
                    STIM.(fields{f})(obs,:) = (grating.(fields{f})(t,:));
                end
            end

            % pull out the second 800ms, after the soa is completed
            obs = obs + 1;


                STIM.('task'){obs,:}  =  paradigm;
                STIM.('trl')(obs,:)   = t;
            STIM.('first800')(obs,:)  = false; 
            STIM.('fullTrial')(obs,:)  = true;
            STIM.('reward')(obs,:)     = true;

            % trigger points
            stimon  =  pEvC{t} == 25; % second stim onset
            stimoff =  pEvC{t} == 26; % last stim offset


            st = double(pEvT{t}(stimon));
            en = double(pEvT{t}(stimoff));

            STIM.tp_ec(obs,:)    = [25 26]; 
            STIM.tp_sp(obs,:)     = [st en]; % Here we only pull out the second event code.
% %             STIM.allEventCodes(obs,:) = pEvC{t};
% %             STIM.allTimePoints(obs,:) = pEvT{t};
           
            % write STIM features
            if t == 1
                STIM.date = STIM.header;
                STIM.startRow = grating.startRow;
                STIM.endRow = grating.endRow;
                STIM.filename = grating.filename;
            end
            fields = fieldnames(grating);
            for f = 1:length(fields)
                if any(strcmp(fields{f},{'endRow','filename','startRow','header'})) 
                    continue
                else
                    STIM.(fields{f})(obs,:) = (grating.(fields{f})(t,:));
                end
            end


        end
        
        


        

        


    end
    STIM = orderfields(STIM);
    
    

    
    
    

    % add Filelist
    STIM.paradigm  = paradigm;
    STIM.fpath     = fpath;
    STIM.runtime   = now;
    

    
