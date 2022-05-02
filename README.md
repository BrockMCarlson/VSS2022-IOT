# VSS2022-IOT

VSS2022-IOT is a Matlab library of code used to analyze the Interocular Transfer of Adaptation in NHP V1
This library is used to generate the figures on Brock Carlson's poster at the VSS 2022 Annual Meeting


## Usage

```matlab
setup_IOT('WorkDir')

# Look at Individual Sessions
processNEV_IOT()

# Create STIM - event-align data
createSTIM_IOT()

# Create IDX - select relevant conditions contrasts
createIDX_IOT()

# Visualize grand average of data
visWithGramm_IOT()
```

## Instructions
The intention is that setupIOT is run at the start of each script so that
individual directories on each local machine can be setup

## Contributing
For collaboration requests please contact brock.m.carlson@vanderbilt.edu

## License
[MIT](https://choosealicense.com/licenses/mit/)
