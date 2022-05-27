# VSS2022-IOT

VSS2022-IOT is a Matlab library of code used to analyze the Interocular Transfer of Adaptation in NHP V1
This library is used to generate the figures on Brock Carlson's poster at the VSS 2022 Annual Meeting


## Usage 
1. Inputs: {.nev, .ns2, .ns6, .bhv}. These files are stored under RIGDIR
2. Setup_IOT: you must establish your home directories for RIGDIR, CODEDIR, OUTDIR_FD, and OUTDIR_PLOT
4. Controller: A_processNEV B_preProcessNeuralData C_visWithMatlab D_visWithGramm


## Full controller interface description

```matlab
1. Plot PSD and CSD with NEV
        Plots CSD and PSD for a given .nev file
        The CSD plots are aligned to every trial's event code from the .nev - no stimulus information available
        Therefore, every photo-diode-triggered onset (or at least every trial start?) is included in the CSD plots
        The PSD plots use the full-session-length data
        SCRIPT: processNEV_IOT()
        OUTPUT: global OUTDIR_PLOT
        

 2. Pre-process Blackrock Files into photodiode triggered and behaviorially aligned data
        This script runs on a single session at a time. This is the most involved script in the controller file for
        this repository because each session requires curated inputs.
        This script takes in .nev, .ns2, .ns6, and .bhv2 files, triggers data to trial onset, and creates a 
        matrix of trial-by-trial stimulus information.
        SCRIPT: preProcessNeuralData_IOT()
        OUTPUT: global OUTDIR_FD

3. This plots smoothed aMUA data. Both for every electrode AND for each recordings pref ori / pref eye determination.
        This script depends on the _FD.mat (formatted data) files. Ouputs are used to update the .xlsx spreadsheets
        .xlsx spreadsheet outpus are used to evaluate the quality and laminar availability of the data.
        aMUA signals are also evaluated from these outputs. 
        visWithMatlab_IOTvsMonoca_aMUA_laminar()
        OUTPUT: global OUTDIR_PLOT

4. This is the script to create all official figures for the VSS 2022 IOT poster
        This script has a custom interface used to select the appropriate sessions with full laminar information for analysis.
        This script depends on _FD.mat (formatted data) files.
        Outputs from this script are used as figures on the VSS2022 poster.
        visWithGramm_IOT()
        OUTPUT: global OUTDIR_PLOT
```

## Instructions
VSS2022-IOT Is built on a Model-Viewer-Control (MVC) framework. This design choice allows for the development of deeper classes and defined layers of abstraction. I am a self-taught dev, so these principals are incorrectly implemented or could be improved please let me know! 

The intention is that each script in the “controller” folder acts as the interface for a class, i.e. users will only need to understand and interact with scripts in the controller folder in order to fully utilize this respository's functionality. 

### “Model” 

  — query the database for appropriate raw data,  
  
  — pre-processes the data with custom butterworth filters, 
  
  — trial aligns the data to event codes, 
  
  — re-defines the pertinent time points to the analog photo diode signal, 
  
  — obtains behavioral information from the MonkeyLogic digital outputs to .NEV files,
   
  — and applies necessary statistical or theoretical models.

**note** 
setupIOT is run at the start of each script so that individual directories on each local machine can be setup. These local directories are the *database* in an         MVC framework.

> Outputs from the model are sent to the base function or “formatted data” (OUTDIR_FD)
  
  
### “View” 
- take _FD and other outputs from model to visualize the data
- do necessary visual processing on the data.



## Contributing
For collaboration requests please contact brock.m.carlson@vanderbilt.edu

## License
[MIT](https://choosealicense.com/licenses/mit/)
