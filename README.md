# VSS2022-IOT

VSS2022-IOT is a Matlab library of code used to analyze the Interocular Transfer of Adaptation in NHP V1
This library is used to generate the figures on Brock Carlson's poster at the VSS 2022 Annual Meeting


## Usage - Access in the Controller Folder

```matlab
1. Plot PSD and CSD with NEV
        Aligns the data to every trial's event code from the .nev - no stimulus information available
        SCRIPT: processNEV_IOT()
        OUTPUT: global OUTDIR_PLOT

 2. Pre-process Blackrock Files into photodiode triggered and behaviorially aligned data
        SCRIPT: preProcessNeuralData_IOT()
        OUTPUT: global OUTDIR_FD

3. This plots smoothed aMUA data. Both for every electrode AND for each recordings pref ori / pref eye determination.
        visWithMatlab_IOTvsMonoca_aMUA_laminar()
        OUTPUT: global OUTDIR_PLOT

4. This is the script to create all official figures for the VSS 2022 IOT poster
        visWithGramm_IOT()
        OUTPUT: global OUTDIR_PLOT
```

## Instructions
VSS2022-IOT Is built on a Model-Viewer-Control (MVC) framework. This design choice allows for the development of deeper classes and defined layers of abstraction. I am a self-taught dev, so these principals are incorrectly implemented or could be improved please let me know! 

The intention is that each script in the “controller” folder acts as the interface for a class, i.e. users will only need to understand and interact with scripts in tue controller folder fully utilize this repos functionality. 

### “Model” 

  — query the database for appropriate raw data,  
  
  — pre-processes the data with custom butterworth filters, 
  
  — trial aligns the data to event codes, 
  
  — re-defines the pertinent time points to the analog photo diode signal, 
  
  — obtains behavioral information from the MonkeyLogic digital outputs to .NEV files,
   
  — and applies necessary statistical or theoretical models.

**note** 
setupIOT is run at the start of each script so that individual directories on each local machine can be setup. These local directories are the *database* in an MVC framework.

> Outputs from the model are sent to the base function or “formatted data” (OUTDIR_FD)
  
  
  
### “View” 





## Contributing
For collaboration requests please contact brock.m.carlson@vanderbilt.edu

## License
[MIT](https://choosealicense.com/licenses/mit/)
