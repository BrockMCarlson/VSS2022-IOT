# VSS2022-IOT

VSS2022-IOT is a Matlab library of code used to analyze the Interocular Transfer of Adaptation in NHP V1
This library is used to generate the figures on Brock Carlson's poster at the VSS 2022 Annual Meeting


## Usage - Access in the Controller Folder

```matlab
# 1. Plot PSD and CSD with NEV
# Alignts to every trial's event code
processNEV_IOT()

# 2. create *_FD.mat in:
        global OUTDIR_FD
    #using:
        preProcessNeuralData_IOT()

# 3. This  does ____________________________
visWithMatlab_IOTvsMonoca_aMUA_laminar

# 4. This does _____________________________
visWithGramm_IOT()
```

## Instructions
The intention is that setupIOT is run at the start of each script so that
individual directories on each local machine can be setup. Please access 
the TEBA folder for 021 data to pull down datafiles onto your local dir.

## Contributing
For collaboration requests please contact brock.m.carlson@vanderbilt.edu

## License
[MIT](https://choosealicense.com/licenses/mit/)
